class Expense {
  final String id;
  final String title;
  final int amount;
  final String payer;
  final DateTime date;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.payer,
    required this.date,
  });
}