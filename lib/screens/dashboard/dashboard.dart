import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/model/categories/categories_provider.dart';
import 'package:pecunia/model/transactions/transactions_provider.dart';
import 'package:pecunia/model/accounts/accounts_provider.dart';
import 'package:pecunia/screens/dashboard/category_expenses.dart';
import 'package:pecunia/widgets/account_card.dart';
import 'package:pecunia/widgets/categoryw.dart';
import 'package:pecunia/widgets/transaction_details.dart';
import 'package:pecunia/widgets/transaction_modal.dart';
import 'package:pecunia/widgets/transactionw.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/accounts/account.dart';
import '../../model/categories/category.dart';
import '../../model/transactions/transaction.dart';
import '../../model/users/user.dart';
import '../../model/users/users_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  int activeCardIndex = 0;

  late UserModel user;

  final PageController _cardController =
      PageController(viewportFraction: 0.7, initialPage: 0);

  final PageController _transactionsController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final categoryList = ref.watch(categoriesProvider);
    final transactionList = ref.watch(transactionsProvider);
    final accountList = ref.watch(accountsProvider);

    final user = ref
        .watch(userProvider(id: Supabase.instance.client.auth.currentUser!.id));

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 18, 20),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        user.when(
                          data: (user) => Text(
                            'Hello ${user.username}!',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          error: (error, stackTrace) => const Text(
                            "Hello User",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          loading: () => const CircularProgressIndicator(),
                        ),
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => transactionModalDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (accountList.when(
                data: (accountListdata) => accountListdata.isNotEmpty,
                loading: () => false,
                error: (error, stackTrace) => false,
              )) ...[
                SizedBox(
                  height: 200,
                  child: accountList.when(
                    data: (accountListdata) => transactionList.when(
                      data: (transactionListdata) => PageView.builder(
                        itemCount: accountListdata.length,
                        controller: _cardController,
                        onPageChanged: (index) => onCardSwipe(index),
                        itemBuilder: (_, i) {
                          final isActive = i == activeCardIndex;
                          return AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutExpo,
                            scale: isActive ? 1 : 0.9,
                            child: AccountCard(
                              id: accountListdata[i].id,
                              name: accountListdata[i].name,
                              onTap: () => {},
                              // onTap: () => _onCardTapped(i),
                              totalBalance: transactionListdata
                                  .where((element) =>
                                      element.account == accountListdata[i].id)
                                  .fold<double>(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          element.amount *
                                              (element.type == 'income'
                                                  ? 1
                                                  : -1))
                                  .toDouble(),
                              income: transactionListdata
                                  .where((element) =>
                                      element.type == 'income' &&
                                      element.account == accountListdata[i].id)
                                  .fold<double>(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element.amount),
                              expense: transactionListdata
                                  .where((element) =>
                                      element.type == 'expense' &&
                                      element.account == accountListdata[i].id)
                                  .fold<double>(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element.amount),
                              active: isActive,
                            ),
                          );
                        },
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(
                  height: 200,
                  child: Center(child: Text("No accounts found")),
                ),
              ],
              const SizedBox(height: 10),
              if (categoryList.when(
                data: (categoryListdata) => categoryListdata.isNotEmpty,
                loading: () => false,
                error: (error, stackTrace) => false,
              )) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: categoryList.when(
                          data: (categoryListdata) => transactionList.when(
                            data: (transactionListdata) => accountList.when(
                              data: (accountListdata) => SizedBox(
                                height: 50,
                                child: PageView.builder(
                                  padEnds: false,
                                  itemCount: categoryListdata.length,
                                  controller:
                                      PageController(viewportFraction: 0.7),
                                  itemBuilder: (context, index) {
                                    var id = categoryListdata[index].id;
                                    var total = transactionListdata
                                        .where((element) =>
                                            element.category ==
                                            categoryListdata[index].id)
                                        .fold<double>(
                                            0,
                                            (previousValue, element) =>
                                                previousValue +
                                                element.amount *
                                                    (element.type == 'income'
                                                        ? 1
                                                        : -1));

                                    return GestureDetector(
                                      onTap: () => context.go(
                                          '/home/dashboard/category_expenses/$id',
                                          extra: CategoryTransactionsParams(
                                            category: categoryListdata[index],
                                            transactions: transactionListdata,
                                            accounts: accountListdata,
                                          )),
                                      child: OpenContainer(
                                        closedElevation: 0,
                                        openElevation: 0,
                                        closedColor: Colors.transparent,
                                        openColor: Colors.transparent,
                                        closedBuilder: (context, action) =>
                                            CategoryW(
                                          category: categoryListdata[index],
                                          total: total,
                                        ),
                                        openBuilder: (context, action) =>
                                            CategoryTransactions(
                                          params: CategoryTransactionsParams(
                                            category: categoryListdata[index],
                                            transactions: transactionListdata,
                                            accounts: accountListdata,
                                          ),
                                        ),
                                      ),
                                      // child: CategoryW(
                                      //   category: categoryListdata[index],
                                      //   total: total,
                                      // ),
                                    );
                                  },
                                ),
                              ),
                              loading: () => const CircularProgressIndicator(),
                              error: (error, stackTrace) => Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            loading: () {
                              return const CircularProgressIndicator();
                            },
                            error: (error, stackTrace) {
                              return Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.red),
                              );
                            },
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) => Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 50,
                          child: Center(child: Text("No categories found")),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              if (categoryList.when(
                data: (categoryListdata) => categoryListdata.isNotEmpty,
                loading: () => false,
                error: (error, stackTrace) => false,
              )) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: transactionList.when(
                      data: (transactionListdata) => categoryList.when(
                        data: (categoryListdata) => accountList.when(
                          data: (accountListdata) => PageView.builder(
                            itemCount: accountListdata.length,
                            controller: _transactionsController,
                            onPageChanged: (index) {
                              onTransactionsSwipe(index);
                            },
                            itemBuilder: (BuildContext context, int pageIndex) {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: transactionListdata.length,
                                itemBuilder: (context, index) {
                                  if (transactionListdata[index].account !=
                                      accountListdata[pageIndex].id) {
                                    return const SizedBox.shrink();
                                  }

                                  final transaction =
                                      transactionListdata[index];
                                  final account = accountListdata.firstWhere(
                                      (element) =>
                                          element.id ==
                                          transactionListdata[index].account);
                                  final category = categoryListdata.firstWhere(
                                      (element) =>
                                          element.id ==
                                          transactionListdata[index].category);

                                  return GestureDetector(
                                    onTap: () => detailsModal(context,
                                        transaction, account, category),
                                    child: Transactionw(
                                      transaction: transactionListdata[index],
                                      account: accountListdata.firstWhere(
                                        (element) =>
                                            element.id ==
                                            transactionListdata[index].account,
                                      ),
                                      category: categoryListdata.firstWhere(
                                        (element) =>
                                            element.id ==
                                            transactionListdata[index].category,
                                      ),
                                    ),
                                    // child: Transactionw(
                                    //   transaction: transactionListdata[index],
                                    //   account: accountListdata.firstWhere(
                                    //     (element) =>
                                    //         element.id ==
                                    //         transactionListdata[index].account,
                                    //   ),
                                    //   category: categoryListdata.firstWhere(
                                    //     (element) =>
                                    //         element.id ==
                                    //         transactionListdata[index]
                                    //             .category,
                                    //   ),
                                    // ),
                                  );
                                },
                              );
                            },
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) => Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) => Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(child: Text("No transactions found")),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void onCardSwipe(int index) {
    return setState(() {
      activeCardIndex = index;
      _transactionsController.animateToPage(activeCardIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate);
    });
  }

  void onTransactionsSwipe(int index) {
    return setState(() {
      activeCardIndex = index;
      _cardController.animateToPage(activeCardIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate);
    });
  }

  Future<dynamic> transactionModalDialog(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return TransactionModal(modalContext: context);
      },
    );
  }

  Future<dynamic> detailsModal(BuildContext context, Transaction transaction,
      Account account, Category category) {
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return TransactionDetails(
            modalContext: context,
            transaction: transaction,
            account: account,
            category: category);
      },
    );
  }
}
