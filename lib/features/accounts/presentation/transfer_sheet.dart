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
  String transferType = "normal";

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
            hint: const Text("Select Destination Account"),
            items: dummyAccounts
                .where((a) => a.id != widget.account.id)
                .map((acc) {
              return DropdownMenuItem(
                value: acc,
                child: Text(acc.cardNumber),
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

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Amount",
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
      showError("Please select destination account");
      return;
    }

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      showError("Invalid amount");
      return;
    }

    int limit = 5000000;
    if (transferType == "same_bank") limit = 20000000;
    if (transferType == "sheba") limit = 50000000;

    if (amount >= limit) {
      showError("Amount exceeds limit for this transfer type");
      return;
    }

    if (amount > widget.account.balance) {
      showError("Insufficient balance");
      return;
    }

    setState(() {
      widget.account.balance -= amount;
      selectedAccount!.balance += amount;

      widget.account.transactions.add(
        TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: "withdraw",
          amount: amount,
          date: DateTime.now(),
          description: "Transfer to ${selectedAccount!.cardNumber}",
        ),
      );

      selectedAccount!.transactions.add(
        TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: "depositt",
          amount: amount,
          date: DateTime.now(),
          description: "Received from ${widget.account.cardNumber}",
        ),
      );
    });

    Navigator.pop(context);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}