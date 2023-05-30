import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/src/utils/capitalize.dart';

enum TransactionType { income, expense }

class TransactionModal extends ConsumerStatefulWidget {
  const TransactionModal({super.key, required this.modalContext});

  final BuildContext modalContext;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionModalState();
}

class _TransactionModalState extends ConsumerState<TransactionModal> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _descriptionController = TextEditingController();

  String _expenseType = TransactionType.expense.toString().split(".").last;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const SizedBox(height: 20),
        const Text('Add Transaction',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
        DefaultTabController(
          length: TransactionType.values.length,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                indicatorColor: Colors.lightGreen,
                onTap: (index) {
                  setState(() {
                    _expenseType = TransactionType.values[index]
                        .toString()
                        .split(".")
                        .last;
                  });
                },
                tabs: TransactionType.values
                    .map((type) =>
                        Tab(text: type.toString().split(".").last.capitalize()))
                    .toList(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TabBarView(
                  children: TransactionType.values
                      .map((type) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Description'),
                                ),
                                const TextField(
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Amount'),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        FilledButton(
            onPressed: Navigator.of(widget.modalContext).pop,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
            child: const Text('Add')),
      ]),
    );
  }
}
