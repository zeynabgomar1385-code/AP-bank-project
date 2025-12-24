import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/expense.dart';

class AddExpenseSheet extends StatefulWidget {
  final Group group;

  const AddExpenseSheet({super.key, required this.group});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedPayer;

  @override
  void initState() {
    super.initState();
    if (widget.group.members.isNotEmpty) {
      _selectedPayer = widget.group.members.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amount = int.tryParse(_amountController.text) ?? 0;

    if (title.isEmpty || amount <= 0 || _selectedPayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields correctly')),
      );
      return;
    }

    widget.group.expenses.add(
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        payer: _selectedPayer!,
        date: DateTime.now(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 18,
        right: 18,
        top: 22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Expense',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Expense title',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedPayer,
              underline: const SizedBox(),
              items: widget.group.members
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedPayer = v;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}