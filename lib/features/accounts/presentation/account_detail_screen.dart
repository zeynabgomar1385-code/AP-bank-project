import 'package:flutter/material.dart';
import '../models/account.dart';
import 'transfer_sheet.dart';

class AccountDetailScreen extends StatelessWidget {
  final Account account;

  const AccountDetailScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final card = account.cardNumber;
    final last4 = card.isNotEmpty ? card.substring(card.length - 4) : '****';

    return Scaffold(
      appBar: AppBar(title: Text('Account • $last4')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => TransferSheet(account: account),
          );
        },
        child: const Icon(Icons.swap_horiz),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.18),
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.32),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Main account',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Icon(Icons.credit_card, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₮ ${account.balance}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    account.cardNumber,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Account: ${account.accountNumber}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Transactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: account.transactions.length,
              itemBuilder: (context, index) {
                final t = account.transactions[index];

                IconData icon;
                Color? color;
                switch (t.type) {
                  case 'deposit':
                    icon = Icons.arrow_downward;
                    color = Colors.green;
                    break;
                  case 'withdraw':
                    icon = Icons.arrow_upward;
                    color = Colors.red;
                    break;
                  default:
                    icon = Icons.swap_horiz;
                    color = Colors.blue;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Icon(icon, color: color),
                    title: Text('${t.amount}'),
                    subtitle: Text(t.description ?? ''),
                    trailing: Text(
                      '${t.date.year}/${t.date.month.toString().padLeft(2, '0')}/${t.date.day.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
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