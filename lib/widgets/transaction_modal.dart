import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/src/utils/capitalize.dart';

enum TransactionType { expense, income }

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
    _dateController.text = DateTime.now().toString().split(" ").first;
  }

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  String _expenseType = TransactionType.expense.toString().split(".").last;

  @override
  Widget build(BuildContext context) {
    final Color addColor = _expenseType == 'expense'
        ? Colors.red
        : _expenseType == 'income'
            ? Colors.blue
            : Colors.green;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Add Transaction',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          DefaultTabController(
            length: TransactionType.values.length,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  indicatorColor: addColor,
                  onTap: (index) {
                    setState(() {
                      _expenseType = TransactionType.values[index]
                          .toString()
                          .split(".")
                          .last;
                    });
                  },
                  tabs: TransactionType.values
                      .map(
                        (type) => Tab(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              color: _expenseType ==
                                      type.toString().split(".").last
                                  ? addColor
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            child: Text(
                              type.toString().split(".").last.capitalize(),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: TransactionType.values
                        .map((type) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 18),
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 21),
                                      Text(
                                        'Account',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 21),
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 21),
                                      Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 21),
                                      Text(
                                        'Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //! Date
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 40,
                                        child: TextField(
                                          controller: _dateController,
                                          keyboardType: TextInputType.none,
                                          onTap: () async {
                                            final DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2015, 8),
                                              lastDate: DateTime(2101),
                                            );
                                            if (picked != null &&
                                                picked != DateTime.now()) {
                                              setState(() {
                                                _dateController.text = picked
                                                    .toString()
                                                    .split(" ")
                                                    .first;
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: addColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //! Account
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 40,
                                        child: TextField(
                                          controller: _accountController,
                                          keyboardType: TextInputType.none,
                                          onTap: null,
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: addColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //! Category
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 40,
                                        child: TextField(
                                          controller: _accountController,
                                          keyboardType: TextInputType.none,
                                          onTap: categoryPicker,
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: addColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 40,
                                        child: TextField(
                                          controller: _descriptionController,
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: addColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 40,
                                        child: TextField(
                                          controller: _descriptionController,
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: addColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: FilledButton(
                onPressed: Navigator.of(widget.modalContext).pop,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightGreen)),
                child: const Text('Save')),
          ),
        ],
      ),
    );
  }

  void categoryPicker() {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFF072E08),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Category',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Row(
                      children: [
                        const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          print('Category $index');
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.category, size: 30),
                              const SizedBox(height: 10),
                              Text('Category $index'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
