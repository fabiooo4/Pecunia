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
    if (transaction.type == 'expense') {
      return ListTile(
        leading: Text('category'),
        title: Text(transaction.description),
        subtitle: Text('account'),
        trailing: Text(
          '€ ${transaction.amount.toString().replaceAll('.', ',')}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else if (transaction.type == 'income') {
      return ListTile(
        leading: Text('category'),
        title: Text(transaction.description),
        subtitle: Text('account'),
        trailing: Text(
          '€ ${transaction.amount.toString().replaceAll('.', ',')}',
          style: const TextStyle(color: Colors.blue),
        ),
      );
    } else {
      return const SizedBox();
    }

    // return SizedBox(
    //   child: ListView.builder(
    //     itemCount: 2,
    //     scrollDirection: Axis.vertical,
    //     itemBuilder: (context, index) {
    //       if (transaction.type == 'expense') {
    //         return ListTile(
    //           leading: Text('category'),
    //           title: Text(transaction.description),
    //           subtitle: Text('account'),
    //           trailing: Text(
    //             '€ ${transaction.amount.toString().replaceAll('.', ',')}',
    //             style: const TextStyle(color: Colors.red),
    //           ),
    //         );
    //       } else if (transaction.type == 'income') {
    //         return ListTile(
    //           leading: Text('category'),
    //           title: Text(transaction.description),
    //           subtitle: Text('account'),
    //           trailing: Text(
    //             '€ ${transaction.amount.toString().replaceAll('.', ',')}',
    //             style: const TextStyle(color: Colors.blue),
    //           ),
    //         );
    //       }
    //       return null;
    //     },
    //   ),
    // );
  }
}
