import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Expense {

  Expense({required this.amount, required this.date, required this.description});

  final String id = uuid.v4();
  final double amount;
  final DateTime date;
  final String description;
}