import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/widgets/transactionw.dart';
import '../model/categories/category.dart';
import '../model/categories/categories_provider.dart';

class CategoryExpenses extends ConsumerWidget {
  const CategoryExpenses({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final List<Category> categoryList = ref.read(categoriesProvider);
    // final category =
    //     categoryList.firstWhere((element) => element.id == categoryId);
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text(category.name),
    //     ),
    //     body: Center(
    //       child: SizedBox(
    //         width: MediaQuery.of(context).size.width/1.10,
    //         child: ListView.builder(itemBuilder: (context, index) {
    //           itemCount: 1;
    //           return SizedBox(
    //             child: Expensew()
    //             );
    //         }),
    //       ),
    //     ));
    return Text("prova");
  }
}
