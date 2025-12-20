
final List<Account> dummyAccounts = [
  Account(
    id: '1',
    cardNumber: '6037 9921 4456 3311',
    accountNumber: '1234567890',
    balance: 12500000,
    transactions: [
      TransactionModel(
        id: 't1',
        type: 'deposit',
        amount: 3000000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Salary',
      ),
      TransactionModel(
        id: 't2',
        type: 'withdraw',
        amount: 500000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'ATM withdrawal',
      ),
      TransactionModel(
        id: 't3',
        type: 'transfer',
        amount: 1000000,
        date: DateTime.now().subtract(const Duration(hours: 10)),
        description: 'Sent to Ali',
      ),
    ],
  ),
  Account(
    id: '2',
    cardNumber: '5022 2910 8845 1290',
    accountNumber: '9098765432',
    balance: 7800000,
    transactions: [
      TransactionModel(
        id: 't4',
        type: 'deposit',
        amount: 2200000,
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Project payment',
      ),
    ],
  ),
];