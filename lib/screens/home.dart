import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/model/categories/category_provider.dart';
import 'package:pecunia/widgets/categoryw.dart';
import '../model/categories/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
  }

  @override
  Widget build(BuildContext context) {
    final List<Category> categoryList = ref.read(categoryProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              context.go('/');
            },
          )
        ],
        title: const Text(
          'Ciao User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: categoryList.length,
                controller: ScrollController(keepScrollOffset: false),
                itemBuilder: (context, index) {
                  var id = categoryList[index].id;
                  var total = 0.0;
                  // for (Expense item in _expenseList) {
                  //   if (item.category == id) {
                  //     total += item.amount;
                  //   }
                  // }
                  return GestureDetector(
                      onTap: () => context.go('/home/category_expenses/$id'),
                      child: CategoryW(
                          category: categoryList[index], total: total));
                })),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[500],
        unselectedItemColor: Colors.grey[500],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
