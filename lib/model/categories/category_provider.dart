import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'category.dart';

final List<Category> _categoryList = [
  Category(name: '🍕 Food'),
  Category(name: '🚗 Transport'),
  Category(name: '🛒 Shopping'),
  Category(name: '🎮 Entertainment'),
  Category(name: '👛 Bills'),
  Category(name: 'Others')
];

final categoryProvider = Provider((ref) => _categoryList);
