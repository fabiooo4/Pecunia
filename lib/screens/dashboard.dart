import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/model/categories/categories_provider.dart';
import 'package:pecunia/model/transactions/transactions_provider.dart';
import 'package:pecunia/model/accounts/accounts_provider.dart';
import 'package:pecunia/widgets/account_card.dart';
import 'package:pecunia/widgets/categoryw.dart';
import 'package:pecunia/widgets/navigation_bar.dart';
import 'package:pecunia/widgets/transactionw.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/users/user.dart';
import '../model/users/users_provider.dart';
import 'package:pecunia/api/sign_in/signin_repository.dart'; // Import the GoRouter instance

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  int activeCardIndex = 0;
  int _index = 0;

  late UserModel user;

  void _onCardTapped(int index) {
    setState(() {
      activeCardIndex = index;
    });
  }

  Future<void> _signOut() async {
    try {
      await ref.read(signInRepositoryProvider).signOut();

      if (mounted) {
        context.go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logged out successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.elliptical(25, 15),
                            right: Radius.elliptical(25, 15)),
                        color: Color.fromARGB(255, 88, 166, 66),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                width: 100,
                                direction: DropdownDirection.left),
                            hint: const Text('Add',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                            onChanged: (value) {
                              switch (value) {
                                case 1:
                                  _showSimpleModalDialogAccount();
                                  break;
                                case 2:
                                  _showSimpleModalDialogCategory();
                                  break;
                                case 3:
                                  _showSimpleModalDialogTransaction();
                                  break;
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                alignment: Alignment.center,
                                child: const Icon(Icons.settings),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                alignment: Alignment.center,
                                child: const Icon(Icons.logout),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                alignment: Alignment.center,
                                child: const Icon(Icons.add),
                                value: 3,
                              ),
                            ],
                          ),
                        ),
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
                        controller: PageController(viewportFraction: 0.7),
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        itemBuilder: (_, i) {
                          final isActive = i == activeCardIndex;
                          return AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutExpo,
                            scale: isActive ? 1 : 0.9,
                            child: AccountCard(
                              id: accountListdata[i].id,
                              name: accountListdata[i].name,
                              onTap: () => _onCardTapped(i),
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
                            data: (transactionListdata) => SizedBox(
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
                                    onTap: () => context
                                        .go('/dashboard/category_expenses/$id'),
                                    child: CategoryW(
                                      category: categoryListdata[index],
                                      total: total,
                                    ),
                                  );
                                },
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
                          data: (accountListdata) => ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: transactionListdata.length,
                            controller: PageController(viewportFraction: 1),
                            itemBuilder: (context, index) {
                              var id = transactionListdata[index].id;
                              if (transactionListdata[index].account !=
                                  accountListdata[activeCardIndex].id) {
                                return const SizedBox.shrink();
                              }

                              return GestureDetector(
                                onTap: () =>
                                    context.go('/dashboard/transaction/$id'),
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
      bottomNavigationBar: const NavBar(active: 0),
    );
  }

  void _showSimpleModalDialogAccount() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: Text("Account"));
        });
  }

    void _showSimpleModalDialogCategory() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Dialog(backgroundColor: Colors.grey, alignment: Alignment.topCenter, child: Text("Category", style: TextStyle(fontSize: 30)));
        });
  }

    void _showSimpleModalDialogTransaction() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: Text("Transaction"));
        });
  }
}
