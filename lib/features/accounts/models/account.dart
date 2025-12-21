import 'transaction.dart';

class Account {
  final String id;

  final String cardNumber;

  final String accountNumber;

  int balance;

  final List<TransactionModel> transactions;

  Account({
    required this.id,
    required this.cardNumber,
    required this.accountNumber,
    required this.balance,
    required this.transactions,
  });
}