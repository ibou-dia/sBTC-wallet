enum TransactionType {
  sent,
  received
}

class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String address;
  final DateTime timestamp;
  final String hash;
  final bool confirmed;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.address,
    required this.timestamp,
    required this.hash,
    this.confirmed = true,
  });

  // Generate some sample transactions
  static List<Transaction> getSampleTransactions() {
    return [
      Transaction(
        id: '1',
        type: TransactionType.received,
        amount: 0.0025,
        address: 'SP2JXKMSH007NPYAQHKJPQMAQYAD90NQGTVJVQ02B',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        hash: '0x1234567890abcdef1234567890abcdef',
      ),
      Transaction(
        id: '2',
        type: TransactionType.sent,
        amount: 0.001,
        address: 'SP1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        hash: '0xabcdef1234567890abcdef1234567890',
      ),
      Transaction(
        id: '3',
        type: TransactionType.received,
        amount: 0.005,
        address: 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        hash: '0x7890abcdef1234567890abcdef123456',
      ),
      Transaction(
        id: '4',
        type: TransactionType.sent,
        amount: 0.0015,
        address: 'SP2837ZMC89J37E31K8KPWSD2DY5RFBJTGZ7BD27A',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        hash: '0xdef1234567890abcdef1234567890abc',
      ),
    ];
  }
}
