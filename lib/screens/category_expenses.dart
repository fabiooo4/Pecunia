import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/widgets/category_transactions.dart';

import '../model/accounts/account.dart';
import '../model/categories/category.dart';
import '../model/transactions/transaction.dart';

class CategoryTransactionsParams {
  const CategoryTransactionsParams({
    required this.category,
    required this.transactions,
    required this.accounts,
  });

  final Category category;
  final List<Transaction> transactions;
  final List<Account> accounts;
}

class CategoryTransactions extends ConsumerWidget {
  const CategoryTransactions({super.key, required this.params});

  final CategoryTransactionsParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params.category.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: € ${params.transactions.fold<double>(
                    0,
                    (previousValue, element) {
                      if (element.type == 'income') {
                        return previousValue + element.amount;
                      } else if (element.type == 'expense') {
                        return previousValue - element.amount;
                      } else {
                        return previousValue;
                      }
                    },
                  ).toStringAsFixed(2).replaceAll('.', ',')}',
            ),
            Text(
              'Incomes: ${params.transactions.where((element) => element.type == 'income').length}',
            ),
            Text(
              'Expenses: ${params.transactions.where((element) => element.type == 'expense').length}',
            ),
            Expanded(
              child: ListView.builder(
                itemCount: params.transactions.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return CategoryTransactionsw(
                    transaction: params.transactions[index],
                    account: params.accounts.firstWhere(
                      (element) =>
                          element.id == params.transactions[index].account,
                    ),
                    category: params.category,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
