import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/transactions/transaction.dart';
import '../model/categories/category.dart';
import '../model/accounts/account.dart';

class Transactionw extends ConsumerWidget {
  const Transactionw({
    Key? key,
    required this.transaction,
    required this.account,
    this.category,
  }) : super(key: key);

  final Transaction transaction;
  final Account account;
  final Category? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transaction.type == 'expense') {
      return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_downward, color: Colors.red),
            Text(category?.name ?? ''),
          ],
        ),
        title: Text(transaction.description ?? ''),
        subtitle: Text(account.name),
        trailing: Text(
          '€ ${transaction.amount.toString().replaceAll('.', ',')}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else if (transaction.type == 'income') {
      return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_upward, color: Colors.blue),
            Text(category?.name ?? ''),
          ],
        ),
        title: Text(transaction.description ?? ''),
        subtitle: Text(account.name),
        trailing: Text(
          '€ ${transaction.amount.toString().replaceAll('.', ',')}',
          style: const TextStyle(color: Colors.blue),
        ),
      );
    } else {
      return const ListTile();
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
