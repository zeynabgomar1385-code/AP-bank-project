import 'package:flutter/material.dart';
import '../data/dummy_accounts.dart';
import 'account_detail_screen.dart';
import 'create_account_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  String _selectedType = 'All';

  String _typeFromAccountNumber(String accountNumber) {
    final parts = accountNumber.split('-');
    final suffix = parts.isNotEmpty ? parts.last.trim() : '';

    if (suffix == '1') return 'Current';
    if (suffix == '2') return 'Savings';
    return 'Other';
  }

  List<dynamic> _filteredAccounts() {
    if (_selectedType == 'All') return dummyAccounts;

    return dummyAccounts.where((acc) {
      final t = _typeFromAccountNumber(acc.accountNumber);
      return t == _selectedType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _filteredAccounts();
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.filter_list, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Type:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedType == 'All',
                        onSelected: (_) => setState(() => _selectedType = 'All'),
                      ),
                      ChoiceChip(
                        label: const Text('Current'),
                        selected: _selectedType == 'Current',
                        onSelected: (_) => setState(() => _selectedType = 'Current'),
                      ),
                      ChoiceChip(
                        label: const Text('Savings'),
                        selected: _selectedType == 'Savings',
                        onSelected: (_) => setState(() => _selectedType = 'Savings'),
                      ),
                      ChoiceChip(
                        label: const Text('Other'),
                        selected: _selectedType == 'Other',
                        onSelected: (_) => setState(() => _selectedType = 'Other'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: accounts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final acc = accounts[index];
                final card = acc.cardNumber;
                final last4 = card.isNotEmpty ? card.substring(card.length - 4) : '****';
                final type = _typeFromAccountNumber(acc.accountNumber);

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountDetailScreen(account: acc),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.14),
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.28),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.credit_card, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '•••• $last4',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Text(
                              '₮ ${acc.balance}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Account: ${acc.accountNumber}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                              ),
                              child: Text(
                                type,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
