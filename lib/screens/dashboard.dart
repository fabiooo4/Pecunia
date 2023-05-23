import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/model/accounts/card.dart';
import 'package:pecunia/model/accounts/card_provider.dart';
import 'package:pecunia/model/categories/categories_provider.dart';
import 'package:pecunia/model/transactions/transactions_provider.dart';
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
    final List<CardAccount> cardAccountList = ref.read(accountProvider);
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        minimumSize: const Size(50, 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    ),
                    ElevatedButton.icon(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: cardAccountList.length,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_, i) {
                    final isActive = i == activeCardIndex;
                    final CardAccount card = cardAccountList[i];

                    return AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutExpo,
                      scale: isActive ? 1 : 0.9,
                      child: AccountCard(
                        name: card.name,
                        onTap: () => _onCardTapped(i),
                        totalBalance: card.totalBalance,
                        income: card.income,
                        expense: card.expense,
                        active: isActive,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: categoryList.when(
                        data: (categoryListdata) => SizedBox(
                          height: 50,
                          child: PageView.builder(
                            padEnds: false,
                            itemCount: categoryListdata.length,
                            controller: PageController(viewportFraction: 0.7),
                            itemBuilder: (context, index) {
                              var id = categoryListdata[index].id;
                              var total = 0.0;
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
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: transactionList.when(
                    data: (transactionListdata) => categoryList.when(
                      data: (categoryListdata) => ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: transactionListdata.length,
                        controller: PageController(viewportFraction: 1),
                        itemBuilder: (context, index) {
                          var id = transactionListdata[index].id;
                          return GestureDetector(
                            onTap: () =>
                                context.go('/dashboard/transaction/$id'),
                            child: Transactionw(
                              transaction: transactionListdata[index],
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
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(active: 0),
    );
  }
}
