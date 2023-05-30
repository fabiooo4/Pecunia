import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        const Text('Add Transaction',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton(
                items: TransactionType.values.map((e) {
                  final value = e.toString().split(".").last;
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _expenseType = value.toString();
                  });
                },
                value: _expenseType),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.4,
              height: MediaQuery.sizeOf(context).height * 0.03,
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    border: OutlineInputBorder(),
                    hintText: 'Description'),
                    controller: _descriptionController,
              ),
            ),
          ],
        ),
        FilledButton(
            onPressed: Navigator.of(widget.modalContext).pop,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            child: const Text('Cancel')),
      ]),
    );
  }
}
