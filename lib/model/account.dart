import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Account {
  Account({required this.name});

  final id = uuid.v4();
  String name;
}
