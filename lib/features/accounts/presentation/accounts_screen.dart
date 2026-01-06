import 'package:flutter/material.dart';
import '../models/account.dart';
import '../data/dummy_accounts.dart';
import '../models/transaction.dart';

class TransferSheet extends StatefulWidget {
  final Account account;

  const TransferSheet({super.key, required this.account});

  @override
  State<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<TransferSheet> {
  Account? selectedAccount;
  final _amountController = TextEditingController();
  final _shebaController = TextEditingController();
  String transferType = "normal";

  @override
  void dispose() {
    _amountController.dispose();
    _shebaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Transfer Money",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          DropdownButton<Account>(
            isExpanded: true,
            value: selectedAccount,
            hint: const Text("Select Destination (for normal/same bank)"),
            items: dummyAccounts
                .where((a) => a.id != widget.account.id)
                .map((acc) {
              return DropdownMenuItem(
                value: acc,
                child: Text('${acc.cardNumber}  •  ${acc.accountNumber}'),
              );
            }).toList(),
            onChanged: (newAcc) {
              setState(() {
                selectedAccount = newAcc;
              });
            },
          ),

          const SizedBox(height: 15),

          DropdownButton<String>(
            isExpanded: true,
            value: transferType,
            items: const [
              DropdownMenuItem(value: "normal", child: Text("Normal Transfer (limit: 5,000,000)")),
              DropdownMenuItem(value: "same_bank", child: Text("Same Bank (limit: 20,000,000)")),
              DropdownMenuItem(value: "sheba", child: Text("Sheba Transfer (limit: 50,000,000)")),
            ],
            onChanged: (v) {
              setState(() {
                transferType = v!;
              });
            },
          ),

          const SizedBox(height: 15),

          if (transferType == 'sheba') ...[
            TextField(
              controller: _shebaController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Destination Sheba (IRxxxxxxxxxxxxxxxxxxxxxxxx)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            DropdownButton<Account>(
              isExpanded: true,
              value: selectedAccount,
              hint: const Text('Select Destination (simulation)'),
              items: dummyAccounts
                  .where((a) => a.id != widget.account.id)
                  .map((acc) {
                return DropdownMenuItem(
                  value: acc,
                  child: Text('${acc.cardNumber}  •  ${acc.accountNumber}'),
                );
              }).toList(),
              onChanged: (newAcc) {
                setState(() {
                  selectedAccount = newAcc;
                });
              },
            ),
            const SizedBox(height: 15),
          ],

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Amount (Toman)",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: submitTransfer,
            child: const Text("Transfer"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void submitTransfer() {
    if (selectedAccount == null) {
      showError('Please select destination');
      return;
    }

    if (transferType == 'sheba') {
      final sheba = _shebaController.text.trim().toUpperCase();
      if (sheba.isEmpty) {
        showError('Please enter destination sheba');
        return;
      }
      if (!sheba.startsWith('IR') || sheba.length != 26) {
        showError('Invalid sheba format');
        return;
      }
    }

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      showError("Invalid amount");
      return;
    }

    int limit = 5000000;
    if (transferType == "same_bank") limit = 20000000;
    if (transferType == "sheba") limit = 50000000;

    if (transferType == 'same_bank') {
      final fromCard = widget.account.cardNumber.replaceAll(' ', '');
      final toCard = selectedAccount!.cardNumber.replaceAll(' ', '');

      if (fromCard.length < 6 || toCard.length < 6) {
        showError('Card number is not valid');
        return;
      }

      final fromBin = fromCard.substring(0, 6);
      final toBin = toCard.substring(0, 6);

      if (fromBin != toBin) {
        showError('Same bank transfer needs same BIN');
        return;
      }
    }

    if (amount > limit) {
      showError("Amount exceeds limit for this transfer type");
      return;
    }

    if (amount > widget.account.balance) {
      showError("Insufficient balance");
      return;
    }

    final baseId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      widget.account.balance -= amount;
      selectedAccount!.balance += amount;

      widget.account.transactions.add(
        TransactionModel(
          id: '${baseId}_out',
          type: "withdraw",
          amount: amount,
          date: DateTime.now(),
          description: 'Transfer (${transferType}) to ${selectedAccount!.cardNumber}',
        ),
      );

      selectedAccount!.transactions.add(
        TransactionModel(
          id: '${baseId}_in',
          type: "deposit",
          amount: amount,
          date: DateTime.now(),
          description: 'Received (${transferType}) from ${widget.account.cardNumber}',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfer done ✅')),
    );

    Navigator.pop(context);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
