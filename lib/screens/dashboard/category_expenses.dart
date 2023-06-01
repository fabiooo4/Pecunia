import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/widgets/category_transactions.dart';

import '../../model/accounts/account.dart';
import '../../model/categories/category.dart';
import '../../model/transactions/transaction.dart';

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
    final filteredTransactions = params.transactions
        .where((element) => element.category == params.category.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            params.category.icon == ''
                ? params.category.name
                : '${params.category.icon} ${params.category.name}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '€ ${filteredTransactions.fold<double>(
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
                      ).toStringAsFixed(2).replaceAll(',', '.')}',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_up, color: Colors.blue),
                    Text(
                      '${filteredTransactions.fold<double>(
                            0,
                            (previousValue, element) {
                              if (element.type == 'income') {
                                return previousValue + element.amount;
                              } else if (element.type == 'expense') {
                                return previousValue;
                              } else {
                                return previousValue;
                              }
                            },
                          ).toStringAsFixed(2).replaceAll(',', '.')} €',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.arrow_drop_down, color: Colors.red),
                    Text(
                      '${filteredTransactions.fold<double>(
                            0,
                            (previousValue, element) {
                              if (element.type == 'income') {
                                return previousValue;
                              } else if (element.type == 'expense') {
                                return previousValue + element.amount;
                              } else {
                                return previousValue;
                              }
                            },
                          ).toStringAsFixed(2).replaceAll(',', '.')} €',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Divider(
              height: 50,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return CategoryTransactionsw(
                    transaction: filteredTransactions[index],
                    account: params.accounts.firstWhere(
                      (element) =>
                          element.id == filteredTransactions[index].account,
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
