import 'package:flutter/material.dart';

import '../model/category.dart';

class CategoryW extends StatefulWidget {
  const CategoryW({super.key, required this.category, required this.total});

  final Category category;
  final double total;

  @override
  State<CategoryW> createState() => _CategoryWState();
}

class _CategoryWState extends State<CategoryW> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(widget.category.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.total.toString().replaceAll('.', ',') + '€', style: const TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }
}