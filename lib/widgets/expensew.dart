import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expensew extends ConsumerWidget {
  const Expensew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/10,
      child: Card(
          child: Column(
            children: [
              Text('Expense'),
            ],
          ),),
    );
  }
}