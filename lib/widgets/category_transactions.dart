import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/transactions/transaction.dart';
import '../model/categories/category.dart';
import '../model/accounts/account.dart';

class CategoryTransactionsw extends ConsumerWidget {
  const CategoryTransactionsw({
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
        leading: const Icon(
          Icons.arrow_downward,
          color: Colors.red,
        ),
        title: Text(transaction.description ?? ''),
        subtitle: Text(
          account.name,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: Text(
          '€ ${transaction.amount.toString().replaceAll(',', '.')}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else if (transaction.type == 'income') {
      return ListTile(
        leading: const Icon(
          Icons.arrow_upward,
          color: Colors.blue,
        ),
        title: Text(transaction.description ?? ''),
        subtitle:
            Text(account.name, style: const TextStyle(color: Colors.black54)),
        trailing: Text(
          '€ ${transaction.amount.toString().replaceAll(',', '.')}',
          style: const TextStyle(color: Colors.blue),
        ),
      );
    } else {
      return const ListTile();
    }
  }
}
