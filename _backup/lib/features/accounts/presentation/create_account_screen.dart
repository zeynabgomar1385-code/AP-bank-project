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

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  String _generateAccountNumber() {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    return now.substring(now.length - 10); // 10 رقم آخر
  }

  String _generateCardNumber() {
    final base = DateTime.now()
        .millisecondsSinceEpoch
        .toString()
        .padLeft(16, '0');

    final s = base.substring(base.length - 16);

    return "${s.substring(0, 4)} "
        "${s.substring(4, 8)} "
        "${s.substring(8, 12)} "
        "${s.substring(12, 16)}";
  }

  void _createAccount() {
    final balance = int.tryParse(_balanceController.text) ?? 0;

    final newAccount = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: _generateCardNumber(),
      accountNumber: _generateAccountNumber(),
      balance: balance,
      transactions: <TransactionModel>[],
    );

    dummyAccounts.add(newAccount);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Initial Balance (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}