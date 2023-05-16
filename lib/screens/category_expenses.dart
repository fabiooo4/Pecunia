import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/categories/category.dart';
import '../model/categories/category_provider.dart';

class CategoryExpenses extends ConsumerWidget {
  const CategoryExpenses({super.key, required this.categoryId});



  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Category> categoryList = ref.read(categoryProvider);
    final category = categoryList.firstWhere((element) => element.id == categoryId);
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Center(
        child: Text(category.name),
      ),
      
    );
  }
}