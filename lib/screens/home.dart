import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/widgets/categoryw.dart';
import '../model/category.dart';
import '../model/expense.dart';

List<Category> category = [
  Category(name: 'Food'),
];

class Home extends StatefulWidget {
  Home({super.key});

  final List<Category> _categoryList = [
    Category(name: 'Food'),
    Category(name: 'Transport'),
    Category(name: 'Shopping'),
    Category(name: 'Entertainment'),
    Category(name: 'Bills'),
    Category(name: 'Others')
  ];

  late final List<Expense> _expenseList = [
    Expense(
        amount: 10.0,
        date: DateTime.now(),
        description: 'Gustoso Paninazzo',
        category: _categoryList[0].id),
  ];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
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
                itemCount: widget._categoryList.length,
                controller: ScrollController(keepScrollOffset: false),
                itemBuilder: (context, index) {
                  var id = widget._categoryList[index].id;
                  var total = 0.0;
                  for (Expense item in widget._expenseList) {
                    if (item.category == id) {
                      total += item.amount;
                    }
                  }
                  return GestureDetector(
                      onTap: () => context.go('/category_expenses/${id}'),
                      child: CategoryW(
                          category: widget._categoryList[index], total: total));
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
