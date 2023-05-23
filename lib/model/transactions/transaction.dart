import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Transaction {
  Transaction(
      {required this.id,
      required this.type,
      required this.amount,
      this.date,
      required this.description,
      this.category,
      this.account});

  String id;
  String type;
  double amount;
  DateTime? date;
  String description;
  String? category;
  String? account;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      amount: json['amount'],
    );
  }
}
