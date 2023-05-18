import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_emoji/dart_emoji.dart';

import '../model/categories/category.dart';

class CategoryW extends ConsumerWidget {
  const CategoryW({Key? key, required this.category, required this.total})
      : super(key: key);

  final Category category;
  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 150, // Set a fixed height to restrict the overall height
      padding: const EdgeInsets.all(2), // Adjust the padding value
      child: Card(
        shape: const CircleBorder(),
        elevation: 0,
        color: Colors.grey[200],
        child: Column(
          children: [
            if (EmojiParser().hasEmoji(category.name.split(' ')[0])) ...[
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name.split(' ')[0],
                      style: const TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      category.name.substring(category.name.indexOf(' ') + 1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${total.toString().replaceAll('.', ',')}€',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Flexible(
                // Wrap the Column with Flexible
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${total.toString().replaceAll('.', ',')}€',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
