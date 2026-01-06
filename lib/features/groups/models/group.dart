import 'expense.dart';

class Group {
  final String id;
  final String name;
  final List<String> members;
  final List<Expense> expenses;

  final String ownerUsername;
  final DateTime createdAt;
  final String description;
  final String currency;

  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.expenses,
    this.ownerUsername = 'unknown',
    DateTime? createdAt,
    this.description = '',
    this.currency = 'IRR',
  }) : createdAt = createdAt ?? DateTime.now();
}
