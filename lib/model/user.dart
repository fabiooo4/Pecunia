import 'package:pecunia/model/account.dart';
import 'package:pecunia/model/category.dart';
import 'package:pecunia/model/expense.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  User({required this.username, required this.email, required this.password});

  final String id = uuid.v4();
  String username;
  String email;
  String password;
  List<Category> categories = [];
  List<Account> accounts = [];
  List<Expense> expenses = [];
}
