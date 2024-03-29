import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/model/categories/categories_provider.dart';
import 'package:pecunia/widgets/category_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/widgets/category_tile_add.dart';

import '../../model/accounts/accounts_provider.dart';
import '../../model/transactions/transactions_provider.dart';
import '../dashboard/category_expenses.dart';

class Categories extends ConsumerStatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final transactionList = ref.watch(transactionsProvider);
    final accountList = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: categories.when(
                  data: (accountListdata) => accountListdata.length + 1,
                  loading: () => 0,
                  error: (error, stackTrace) => 0,
                ),
                controller: ScrollController(keepScrollOffset: false),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const CategoryTileAdd();
                  }
                  final category = categories.when(
                    data: (accountListdata) => accountListdata[index - 1],
                    loading: () => null,
                    error: (error, stackTrace) => null,
                  );
                  return CategoryTile(
                    id: category!.id,
                    name: category.name.toString(),
                    icon: category.icon.toString(),
                    onTap: () {
                      context.go(
                        '/home/dashboard/category_expenses/${category.id}',
                        extra: CategoryTransactionsParams(
                            category: category,
                            transactions: transactionList.when(
                              data: (transactionListdata) =>
                                  transactionListdata,
                              loading: () => [],
                              error: (error, stackTrace) => [],
                            ),
                            accounts: accountList.when(
                              data: (accountListdata) => accountListdata,
                              loading: () => [],
                              error: (error, stackTrace) => [],
                            )),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
