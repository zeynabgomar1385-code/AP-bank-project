import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/accounts/presentation/accounts_screen.dart';
import 'package:flutter_application_1/features/groups/presentation/groups_screen.dart';
import 'package:flutter_application_1/features/accounts/data/dummy_accounts.dart';
import 'package:flutter_application_1/features/groups/data/dummy_groups.dart';
import 'package:flutter_application_1/features/accounts/presentation/create_account_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String? name;

  const HomeScreen({
    super.key,
    required this.username,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    final totalBalance =
        dummyAccounts.fold<int>(0, (sum, acc) => sum + acc.balance);
    final accountsCount = dummyAccounts.length;
    final groupsCount = dummyGroups.length;

    final previewAccounts = dummyAccounts.take(2).toList();
    final previewGroups = dummyGroups.take(2).toList();

    final List<_ActivityItem> activities = [];
    for (final acc in dummyAccounts) {
      for (final t in acc.transactions) {
        activities.add(
          _ActivityItem(
            title: 'Transfer ${t.type}',
            subtitle: '${acc.cardNumber} • ${t.amount}',
            date: t.date,
          ),
        );
      }
    }
    for (final g in dummyGroups) {
      for (final e in g.expenses) {
        activities.add(
          _ActivityItem(
            title: 'Group: ${g.name}',
            subtitle: '${e.payer} paid ${e.amount} for ${e.title}',
            date: e.date,
          ),
        );
      }
    }
    activities.sort((a, b) => b.date.compareTo(a.date));
    final recentActivities = activities.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hi, ${name?.trim().isNotEmpty == true ? name!.trim() : username} 👋',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Here is your overview for today',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₮ $totalBalance',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('$accountsCount accounts'),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.people,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('$groupsCount groups'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Transfer'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateAccountScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_card),
                        label: const Text('New Account'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GroupsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.group_add),
                        label: const Text('Groups'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServicesScreen(
                            username: username,
                            name: name,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.miscellaneous_services),
                    label: const Text('Services'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Accounts',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountsScreen(),
                            ),
                          );
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...previewAccounts.map(
                    (acc) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(acc.cardNumber),
                        subtitle: Text('Balance: ${acc.balance}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shared Groups',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GroupsScreen(),
                            ),
                          );
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...previewGroups.map(
                    (g) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.group),
                        title: Text(g.name),
                        subtitle: Text('${g.members.length} members'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GroupsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  ...recentActivities.map(
                    (a) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(a.title),
                      subtitle: Text(a.subtitle),
                      trailing: Text(
                        '${a.date.month}/${a.date.day}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            username: username,
                            initialName: name,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesScreen extends StatelessWidget {
  final String username;
  final String? name;

  const ServicesScreen({
    super.key,
    required this.username,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone_iphone),
              title: const Text('Buy Top Up'),
              subtitle: const Text('Mobile recharge (MCI / MTN / RTL)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  builder: (_) => const _TopUpSheet(),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Pay Bills'),
              subtitle: const Text('Electricity, Water, Gas (demo)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  builder: (_) => const _BillPaySheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final String subtitle;
  final DateTime date;

  _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.date,
  });
}

class _TopUpSheet extends StatefulWidget {
  const _TopUpSheet();

  @override
  State<_TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends State<_TopUpSheet> {
  final _phoneController = TextEditingController();
  String _operator = 'MCI';
  int? _amount;
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _buy() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter phone number')));
      return;
    }

    if (!RegExp(r'^09\d{9}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Phone must be like 09xxxxxxxxx')));
      return;
    }

    if (_amount == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select an amount')));
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Top up successful ✅  ($_operator - $phone - $_amount)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_iphone),
              const SizedBox(width: 8),
              Text(
                'Buy Top Up',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _operator,
            items: const [
              DropdownMenuItem(value: 'MCI', child: Text('Hamrah Aval (MCI)')),
              DropdownMenuItem(value: 'MTN', child: Text('Irancell (MTN)')),
              DropdownMenuItem(value: 'RTL', child: Text('Rightel (RTL)')),
            ],
            onChanged: (v) {
              if (v == null) return;
              setState(() => _operator = v);
            },
            decoration: const InputDecoration(
              labelText: 'Operator',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone (09xxxxxxxxx)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Amount',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _AmountChip(
                label: '10,000',
                selected: _amount == 10000,
                onTap: () => setState(() => _amount = 10000),
              ),
              _AmountChip(
                label: '20,000',
                selected: _amount == 20000,
                onTap: () => setState(() => _amount = 20000),
              ),
              _AmountChip(
                label: '50,000',
                selected: _amount == 50000,
                onTap: () => setState(() => _amount = 50000),
              ),
              _AmountChip(
                label: '100,000',
                selected: _amount == 100000,
                onTap: () => setState(() => _amount = 100000),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _buy,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Pay'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.16)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _BillPaySheet extends StatefulWidget {
  const _BillPaySheet();

  @override
  State<_BillPaySheet> createState() => _BillPaySheetState();
}

class _BillPaySheetState extends State<_BillPaySheet> {
  final _billIdController = TextEditingController();
  final _payIdController = TextEditingController();
  final _amountController = TextEditingController();

  String _type = 'Electricity';
  bool _loading = false;

  @override
  void dispose() {
    _billIdController.dispose();
    _payIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  bool _isDigits(String s) => RegExp(r'^\d+$').hasMatch(s);

  void _pay() async {
    final billId = _billIdController.text.trim();
    final payId = _payIdController.text.trim();
    final amountText = _amountController.text.trim();

    if (billId.isEmpty || payId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter bill id and pay id')));
      return;
    }

    if (!_isDigits(billId) || !_isDigits(payId)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bill id / Pay id must be numbers')));
      return;
    }

    if (billId.length < 6 || payId.length < 6) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bill id / Pay id is too short')));
      return;
    }

    int? amount;
    if (amountText.isNotEmpty) {
      amount = int.tryParse(amountText.replaceAll(',', ''));
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Amount is not valid')));
        return;
      }
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bill paid ✅  ($_type | bill:$billId | pay:$payId${amount != null ? ' | $amount' : ''})',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long),
              const SizedBox(width: 8),
              Text(
                'Pay Bills',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _type,
            items: const [
              DropdownMenuItem(value: 'Electricity', child: Text('Electricity')),
              DropdownMenuItem(value: 'Water', child: Text('Water')),
              DropdownMenuItem(value: 'Gas', child: Text('Gas')),
            ],
            onChanged: (v) {
              if (v == null) return;
              setState(() => _type = v);
            },
            decoration: const InputDecoration(
              labelText: 'Bill type',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _billIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Bill ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _payIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Payment ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _pay,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Pay'),
            ),
          ),
        ],
      ),
    );
  }
}
