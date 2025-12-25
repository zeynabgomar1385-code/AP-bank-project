class TransactionModel {
  final String id;
  final String type; 
  final int amount;
  final DateTime date;
  final String? description;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
  });
}