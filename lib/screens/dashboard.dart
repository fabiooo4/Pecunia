import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/model/accounts/card.dart';
import 'package:pecunia/model/accounts/card_provider.dart';
import 'package:pecunia/model/categories/category.dart';
import 'package:pecunia/model/categories/category_provider.dart';
import 'package:pecunia/widgets/account_card.dart';
import 'package:pecunia/widgets/categoryw.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/users/user.dart';
import '../model/users/users_provider.dart';
import 'package:pecunia/api/sign_in/signin_repository.dart';

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
    final List<Category> categoryList = ref.read(categoryProvider);
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
                          data: (user) => Text('Hello ${user.username}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                          error: (error, stackTrace) => const Text("Hello User",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                          loading: () => const CircularProgressIndicator(),
                        ),
                        Text(
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
                    print(card);

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
                    child: SizedBox(
                      height: 150,
                      child: PageView.builder(
                        itemCount: categoryList.length,
                        controller: PageController(viewportFraction: 0.3),
                        itemBuilder: (context, index) {
                          var id = categoryList[index].id;
                          var total = 0.0;
                          // for (Expense item in _expenseList) {
                          //   if (item.category == id) {
                          //     total += item.amount;
                          //   }
                          // }
                          return GestureDetector(
                            onTap: () =>
                                context.go('/dashboard/category_expenses/$id'),
                            child: CategoryW(
                              category: categoryList[index],
                              total: total,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
