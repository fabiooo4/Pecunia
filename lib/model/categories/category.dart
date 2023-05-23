import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {
  Category({required this.id, required this.name, this.categoryIcon});

  String id;
  String name;
  String? categoryIcon;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
