import 'package:pecunia/model/account.dart';
import 'package:pecunia/model/category.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Expense {
  Expense(
      {required this.amount,
      required this.date,
      required this.description,
      required this.category,
      required this.account});

  final String id = uuid.v4();
  double amount;
  DateTime date = DateTime.now();
  String description;
  Category category = Category(name: "Uncategorized");
  Account account = Account(name: "Main Account");
}
