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
    return SizedBox(
      height: 10,
      width: 10,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                      // child: category.icon,
                    ),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                '${total.toString().replaceAll('.', ',')}€',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
