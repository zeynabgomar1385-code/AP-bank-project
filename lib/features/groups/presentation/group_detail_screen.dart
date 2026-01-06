import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/group.dart';
import '../models/expense.dart';
import 'add_expense_sheet.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  Map<String, int> _calculateBalances(Group g) {
    final int total = g.expenses.fold(0, (sum, e) => sum + e.amount);
    if (g.members.isEmpty) return {};

    final int share = (total / g.members.length).round();

    final Map<String, int> paid = {for (var m in g.members) m: 0};

    for (final Expense e in g.expenses) {
      paid[e.payer] = (paid[e.payer] ?? 0) + e.amount;
    }

    final Map<String, int> balance = {};
    for (final m in g.members) {
      balance[m] = (paid[m] ?? 0) - share;
    }
    return balance;
  }

  int _total(Group g) => g.expenses.fold(0, (sum, e) => sum + e.amount);

  List<Map<String, dynamic>> _buildSettlementPlan(Map<String, int> balances) {

    final creditors = <Map<String, dynamic>>[]; // {name, amount}
    final debtors = <Map<String, dynamic>>[]; // {name, amount}

    balances.forEach((name, bal) {
      if (bal > 0) {
        creditors.add({'name': name, 'amount': bal});
      } else if (bal < 0) {
        debtors.add({'name': name, 'amount': -bal});
      }
    });

    int i = 0;
    int j = 0;
    final plan = <Map<String, dynamic>>[];

    while (i < debtors.length && j < creditors.length) {
      final d = debtors[i];
      final c = creditors[j];

      final int pay = d['amount'] as int;
      final int recv = c['amount'] as int;

      final int amt = pay < recv ? pay : recv;

      plan.add({
        'from': d['name'],
        'to': c['name'],
        'amount': amt,
      });

      d['amount'] = pay - amt;
      c['amount'] = recv - amt;

      if ((d['amount'] as int) == 0) i++;
      if ((c['amount'] as int) == 0) j++;
    }

    return plan;
  }

  String _buildReportText() {
    final g = widget.group;
    final balances = _calculateBalances(g);
    final plan = _buildSettlementPlan(balances);
    final total = _total(g);

    final b = StringBuffer();

    b.writeln('=== Group Report ===');
    b.writeln('Group: ${g.name}');
    b.writeln('Members: ${g.members.length}');
    b.writeln('Total Expenses: $total');
    b.writeln('');

    b.writeln('--- Members Balance ---');
    for (final m in g.members) {
      final bal = balances[m] ?? 0;
      if (bal > 0) {
        b.writeln('- $m: +$bal (receive)');
      } else if (bal < 0) {
        b.writeln('- $m: $bal (pay)');
      } else {
        b.writeln('- $m: 0 (settled)');
      }
    }
    b.writeln('');

    b.writeln('--- Suggested Settlement ---');
    if (plan.isEmpty) {
      b.writeln('Everyone is settled ✅');
    } else {
      for (final p in plan) {
        b.writeln('${p['from']} -> ${p['to']} : ${p['amount']}');
      }
    }
    b.writeln('');

    b.writeln('--- Expenses ---');
    if (g.expenses.isEmpty) {
      b.writeln('No expenses');
    } else {
      for (final e in g.expenses) {
        b.writeln('- ${e.title} | payer: ${e.payer} | amount: ${e.amount} | date: ${e.date.year}/${e.date.month}/${e.date.day}');
      }
    }

    return b.toString();
  }

  Future<void> _exportReport() async {
    try {
      final text = _buildReportText();

      final dir = Directory.systemTemp;
      final safeName = widget.group.name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
      final ts = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/group_report_${safeName}_$ts.txt');

      await file.writeAsString(text);

      if (!mounted) return;

      await Clipboard.setData(ClipboardData(text: file.path));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report saved ✅  (path copied)\n${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  void _showFinalResult() {
    final balances = _calculateBalances(widget.group);
    final plan = _buildSettlementPlan(balances);
    final reportText = _buildReportText();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Final Result'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Members balance:'),
                  const SizedBox(height: 8),
                  ...widget.group.members.map((m) {
                    final bal = balances[m] ?? 0;
                    String text;
                    if (bal > 0) {
                      text = '+$bal (receive)';
                    } else if (bal < 0) {
                      text = '$bal (pay)';
                    } else {
                      text = '0 (settled)';
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('- $m: $text'),
                    );
                  }).toList(),

                  const SizedBox(height: 14),
                  const Text('Suggested settlement:'),
                  const SizedBox(height: 8),

                  if (plan.isEmpty)
                    const Text('Everyone is settled ✅')
                  else
                    ...plan.map((p) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${p['from']} → ${p['to']} : ${p['amount']}',
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: reportText));
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report copied ✅')),
                );
              },
              child: const Text('Copy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exportReport();
              },
              child: const Text('Export'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final balances = _calculateBalances(widget.group);
    final total = _total(widget.group);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          TextButton.icon(
            onPressed: _showFinalResult,
            icon: const Icon(Icons.summarize, size: 18),
            label: const Text('Final'),
          ),
          TextButton.icon(
            onPressed: _exportReport,
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Export'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddExpenseSheet(group: widget.group),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.group, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          widget.group.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.group.members.length} members',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Owner: ${widget.group.ownerUsername}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Currency: ${widget.group.currency}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (widget.group.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.group.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Total expenses: $total',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Members balance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.group.members.map((m) {
                      final bal = balances[m] ?? 0;
                      String text;
                      Color color;

                      if (bal > 0) {
                        text = '+$bal (should receive)';
                        color = Colors.green;
                      } else if (bal < 0) {
                        text = '$bal (should pay)';
                        color = Colors.red;
                      } else {
                        text = 'settled';
                        color = Colors.grey;
                      }

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            m.isNotEmpty ? m[0].toUpperCase() : '?',
                          ),
                        ),
                        title: Text(m),
                        trailing: Text(
                          text,
                          style: TextStyle(color: color),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Expenses',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            ...widget.group.expenses.map(
              (e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(e.title),
                  subtitle: Text('${e.payer} • ${e.amount}'),
                  trailing: Text(
                    '${e.date.month}/${e.date.day}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
