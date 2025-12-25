import 'package:flutter/material.dart';
import '../data/dummy_groups.dart';
import 'group_detail_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Groups')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyGroups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final g = dummyGroups[index];
          final members = g.members.join(', ');
          final int total = g.expenses.fold<int>(0, (sum, e) => sum + e.amount);

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupDetailScreen(group: g),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.24),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.group, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          g.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${g.members.length} members',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    members,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total expenses: $total',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}