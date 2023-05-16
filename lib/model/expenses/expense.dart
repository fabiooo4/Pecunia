import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Expense {
  Expense(
      {required this.amount,
      this.date,
      required this.description,
      this.category,
      this.account});

  final String id = uuid.v4();
  double amount;
  DateTime? date;
  String description;
  String? category;
  String? account;
}
