import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {
  Category({required this.name});

  final id = uuid.v4();
  final String name; 
}