import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {
  Category({required this.name, required this.icon});

  final id = uuid.v4();
  Icon icon;
  String name;
}
