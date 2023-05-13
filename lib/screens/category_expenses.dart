import 'package:flutter/material.dart';

class CategoryExpenses extends StatefulWidget {
  const CategoryExpenses({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<CategoryExpenses> createState() => _CategoryExpensesState();
}

class _CategoryExpensesState extends State<CategoryExpenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text(widget.categoryId),

    );
  }
}