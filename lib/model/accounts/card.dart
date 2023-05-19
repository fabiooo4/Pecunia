import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CardAccount {
  CardAccount({
    required this.name,
    required this.totalBalance,
    required this.income,
    required this.expense,
  });

  final id = uuid.v4();
  String name;
  double totalBalance;
  double income;
  double expense;
  bool active = false;
}
