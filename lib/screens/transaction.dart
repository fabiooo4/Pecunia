import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key, required this.transactionId});

  final String transactionId;

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
    return const Text("prova");
  }
}
