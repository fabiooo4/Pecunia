import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/model/accounts/account.dart';
import 'package:pecunia/model/transactions/transaction.dart';
import 'package:pecunia/model/categories/category.dart';

class TransactionPageParams {
  const TransactionPageParams({
    required this.transaction,
    required this.account,
    required this.category,
  });

  final Transaction transaction;
  final Account account;
  final Category category;
}

class TransactionPage extends ConsumerWidget {
  const TransactionPage({
    Key? key,
    required this.params,
  }) : super(key: key);

  final TransactionPageParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params.transaction.description ?? 'Transaction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${params.transaction.description}',
            ),
            Text(
              'Amount: € ${params.transaction.amount}',
            ),
            Text(
              'Type: ${params.transaction.type}',
            ),
            Text(
              'Date: ${params.transaction.date}',
            ),
            Text(
              'Account: ${params.account.name}',
            ),
            Text(
              'Category: ${params.category.name}',
            ),
          ],
        ),
      ),
    );
  }
}
