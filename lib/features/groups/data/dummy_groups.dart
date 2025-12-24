import '../models/group.dart';
import '../models/expense.dart';

final List<Group> dummyGroups = [
  Group(
    id: 'g1',
    name: 'Dorm Room',
    members: ['Zeynab', 'Reza', 'Mina'],
    expenses: [
      Expense(
        id: 'e1',
        title: 'Internet bill',
        amount: 300000,
        payer: 'Zeynab',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Expense(
        id: 'e2',
        title: 'Groceries',
        amount: 450000,
        payer: 'Mina',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  ),
  Group(
    id: 'g2',
    name: 'Trip to North',
    members: ['Zeynab', 'Sam', 'Sara', 'Nima'],
    expenses: [
      Expense(
        id: 'e3',
        title: 'Gas',
        amount: 600000,
        payer: 'Sam',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ],
  ),
];