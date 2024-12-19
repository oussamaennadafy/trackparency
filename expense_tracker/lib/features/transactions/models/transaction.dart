class TransactionType {
  static const expense = "EXPENSE";
  static const income = "INCOME";
}

class Transaction {
  const Transaction({
    this.id,
    required this.paymentMethod,
    required this.category,
    required this.title,
    required this.price,
    required this.comment,
    required this.timestamp,
    required this.type,
  });

  final String? id;
  final String paymentMethod;
  final String category;
  final String title;
  final int price;
  final String comment;
  final DateTime timestamp;
  final String type;
}
