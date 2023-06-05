import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/model/accounts/accounts_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/accounts/account.dart';
import '../model/transactions/transaction.dart';
import '../model/transactions/transactions_provider.dart';

class AccountTile extends ConsumerStatefulWidget {
  const AccountTile(
      {Key? key,
      required this.account,
      required this.transactions,
      required this.onTap})
      : super(key: key);

  final Account account;
  final List<Transaction> transactions;
  final VoidCallback onTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountTileState();
}

class _AccountTileState extends ConsumerState<AccountTile> {
  final TextEditingController nameController = TextEditingController();

  String? errorMessage;

  @override
  void initState() {
    nameController.addListener(() => setState(() {}));

    nameController.text = widget.account.name;

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = widget.transactions.fold<double>(
        0, (previousValue, element) => previousValue + element.amount);

    final totalIncome = widget.transactions.fold<double>(
        0,
        (previousValue, element) =>
            previousValue + (element.amount > 0 ? element.amount : 0));

    final totalExpense = widget.transactions.fold<double>(
        0,
        (previousValue, element) =>
            previousValue + (element.amount < 0 ? element.amount : 0));

    return GestureDetector(
      onTapUp: (details) {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        final relativePosition = RelativeRect.fromRect(
          Rect.fromPoints(
            details.globalPosition,
            details.globalPosition,
          ),
          Offset.zero & overlay.size,
        );

        showMenu(
          context: context,
          position: relativePosition,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              value: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                // name from widget
                                'Edit "${widget.account.name}"',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF072E08),
                                ),
                              ),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.width * 0.18,
                                child: Center(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.black26),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.black26),
                                      ),
                                      labelText: 'Account Name',
                                      labelStyle: const TextStyle(
                                          color: Color(0xFF072E08)),
                                      errorText: errorMessage,
                                    ),
                                    controller: nameController,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (validateName()) {
                                      setState(() {
                                        errorMessage = null;
                                      });
                                      editAccount(
                                        widget.account.id,
                                        nameController.text,
                                      );
                                      ref.invalidate(accountsProvider);
                                      ref.invalidate(transactionsProvider);
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        errorMessage = 'Please enter a name';
                                      });
                                    }
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            );
                          },
                        );
                      });
                },
                child: const ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit"),
                ),
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Delete "${widget.account.name}"',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF072E08),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Are you sure you want to delete "${widget.account.name}"?',
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'All transactions under this account will be deleted.',
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'This action cannot be reversed!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                deleteAccount(widget.account.id);
                                ref.invalidate(accountsProvider);
                                ref.invalidate(transactionsProvider);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: const ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                ),
              ),
            ),
          ],
        );
      },
      onTap: widget.onTap,
      child: Card(
        elevation: 0,
        color: const Color(0xFF072E08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                widget.account.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                '€ ${totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    overflow: TextOverflow.fade),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteAccount(String id) async {
    await Supabase.instance.client
        .from('accounts')
        .delete()
        .match({'id': id}).then((value) {
      ref.invalidate(accountsProvider);
      ref.invalidate(transactionsProvider);
    });
  }

  Future<void> editAccount(String id, String newName) async {
    await Supabase.instance.client
        .from('accounts')
        .update({'name': newName}).match({'id': id}).then(
            (value) => ref.invalidate(accountsProvider));
  }

  bool validateName() {
    if (nameController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
