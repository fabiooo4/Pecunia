import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/model/accounts/accounts_provider.dart';
import 'package:pecunia/src/utils/capitalize.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/categories/categories_provider.dart';
import '../model/transactions/transactions_provider.dart';

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

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _expenseType = TransactionType.expense.toString().split(".").last;
  String selectedCategoryId = '';
  String selectedAccountId = '';

  @override
  Widget build(BuildContext context) {
    final Color addColor = _expenseType == 'expense'
        ? Colors.red
        : _expenseType == 'income'
            ? Colors.blue
            : Colors.lightGreen;

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
                        .map(
                          (type) => Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      'Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      'Account',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 40,
                                      child: TextField(
                                        controller: _accountController,
                                        keyboardType: TextInputType.none,
                                        onTap: accountPicker,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      'Category',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 40,
                                      child: TextField(
                                        controller: _categoryController,
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
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      'Amount',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 40,
                                      child: TextField(
                                        controller: _amountController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              // allow digits and dot
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      'Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: FilledButton(
                onPressed: addTransaction,
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
    ref.invalidate(categoriesProvider);
    final categoryList = ref.watch(categoriesProvider);
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
        height: MediaQuery.of(context).size.height * 0.45,
        child: categoryList.when(
          data: (categoryListdata) => Column(
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
                      const Text(
                        'Category',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Row(
                        children: [
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(categoryListdata.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            print(categoryListdata[index].name);
                            print(categoryListdata[index].id);
                            _categoryController.text =
                                '${categoryListdata[index].icon} ${categoryListdata[index].name}';
                            selectedCategoryId = categoryListdata[index].id;
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(100, 139, 195, 74),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (categoryListdata[index].icon != '') ...[
                                  Text(
                                    categoryListdata[index].icon.toString(),
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    categoryListdata[index].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF072E08),
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    categoryListdata[index].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF072E08),
                                    ),
                                  ),
                                ],
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  void accountPicker() {
    final accountList = ref.watch(accountsProvider);
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
        height: MediaQuery.of(context).size.height * 0.45,
        child: accountList.when(
          data: (accountListdata) => Column(
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
                      const Text(
                        'Account',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Row(
                        children: [
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(accountListdata.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            _accountController.text =
                                accountListdata[index].name;
                            selectedAccountId = accountListdata[index].id;
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
                                Text(
                                  accountListdata[index].name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  void createCategory() {
    print('TODO create category');
  }

  void createAccount() {
    print('TODO create account');
  }

  Future<void> addTransaction() async {
    await Supabase.instance.client.from('transactions').insert([
      {
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'description': _descriptionController.text,
        'amount': _amountController.text,
        'created_at': _dateController.text,
        'category_id': selectedCategoryId,
        'account_id': selectedAccountId,
        'type': _expenseType,
      }
    ]).then((value) {
      // ignore: unused_result
      ref.refresh(transactionsProvider);
      Navigator.of(context).pop();
    }).catchError((error) {
      print(error);
    });
  }
}
