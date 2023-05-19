import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  User({required this.id, required this.username});

  String id;
  String username;

  
}
