import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/categories/category.dart';

class CategoryW extends ConsumerWidget {
  const CategoryW({Key? key, required this.category, required this.total})
      : super(key: key);

  final Category category;
  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(100, 139, 195, 74),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    category.icon == ''
                        ? category.name
                        : '${category.icon} ${category.name}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
