import 'dart:math';

import 'package:flutter/material.dart';
import '../data/dummy_accounts.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _balanceController = TextEditingController();
  final _nicknameController = TextEditingController();

  String _type = 'current';
  bool _loading = false;

  @override
  void dispose() {
    _balanceController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  int _parseAmount(String text) {
    final cleaned = text.trim().replaceAll(',', '');
    if (cleaned.isEmpty) return 0;
    return int.tryParse(cleaned) ?? 0;
  }

  String _generateAccountNumber(String type) {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final core = now.length >= 10 ? now.substring(now.length - 10) : now.padLeft(10, '0');
    final suffix = type == 'current' ? '1' : '2';
    return '$core-$suffix';
  }

  String _generateCardNumber() {
    final r = Random();
    final prefix = '603799';
    final rest = List.generate(10, (_) => r.nextInt(10)).join();
    final raw = prefix + rest;

    return '${raw.substring(0, 4)} '
        '${raw.substring(4, 8)} '
        '${raw.substring(8, 12)} '
        '${raw.substring(12, 16)}';
  }

  void _createAccount() async {
    final balance = _parseAmount(_balanceController.text);

    if (balance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Balance must be >= 0')),
      );
      return;
    }

    if (balance > 0 && balance < 100000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum initial deposit is 100,000')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final nickname = _nicknameController.text.trim();
    final newAccount = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: _generateCardNumber(),
      accountNumber: _generateAccountNumber(_type),
      balance: balance,
      transactions: <TransactionModel>[],
    );

    dummyAccounts.add(newAccount);

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Account created ✅  (${_type == 'current' ? 'Current' : 'Savings'}${nickname.isNotEmpty ? ' - $nickname' : ''})',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'current', child: Text('Current Account')),
                DropdownMenuItem(value: 'savings', child: Text('Savings Account')),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _type = v);
              },
              decoration: const InputDecoration(
                labelText: 'Account Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Initial Deposit (optional)',
                border: OutlineInputBorder(),
                helperText: 'If you enter a deposit, minimum is 100,000',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _createAccount,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
