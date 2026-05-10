class Transaction {
  final String id;
  final String type;
  final double amount;
  final String timestamp;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      timestamp: json['timestamp'],
    );
  }
}
