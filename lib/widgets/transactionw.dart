import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/transactions/transaction.dart';

class Transactionw extends ConsumerWidget {
  const Transactionw({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ListTile(
            title: Text('Transaction'),
            subtitle: Text('Transaction'),
            trailing: Text('Transaction'),
          );
        },
      ),
    );
  }
}
