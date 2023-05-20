import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'category.dart';

final List<Category> _categoryList = [
  Category(name: "Bills", icon: const Icon(Icons.attach_money)),
  Category(name: "Food", icon: const Icon(Icons.food_bank)),
  Category(name: "Transport", icon: const Icon(Icons.car_rental)),
  Category(name: "Shopping", icon: const Icon(Icons.shopping_cart)),
  Category(name: "Entertainment", icon: const Icon(Icons.movie)),
  Category(name: "Health", icon: const Icon(Icons.medical_services)),
  Category(name: "Travel", icon: const Icon(Icons.flight)),
  Category(name: "Education", icon: const Icon(Icons.school)),
  Category(name: "Gifts", icon: const Icon(Icons.card_giftcard)),
  Category(name: "Other", icon: const Icon(Icons.more_horiz)),
];

final categoryProvider = Provider((ref) => _categoryList);
