import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/categories/category.dart';

class CategoryW extends ConsumerWidget {
  const CategoryW({super.key, required this.category, required this.total});

  final Category category;
  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 0,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${total.toString().replaceAll('.', ',')}€', style: const TextStyle(fontSize: 20))
          ],
        ),
      ),
    );;
  }
}