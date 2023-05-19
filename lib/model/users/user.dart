import 'package:uuid/uuid.dart';

const uuid = Uuid();

class UserModel {
  UserModel({required this.id, required this.username});
  String id;
  String username;
}
