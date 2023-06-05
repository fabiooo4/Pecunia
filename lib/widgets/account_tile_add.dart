import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/accounts/accounts_provider.dart';

class AccountTileAdd extends ConsumerStatefulWidget {
  const AccountTileAdd({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountTileAddState();
}

class _AccountTileAddState extends ConsumerState<ConsumerStatefulWidget> {
  final TextEditingController _nameController = TextEditingController();

  String? errorMessage;

  @override
  void initState() {
    _nameController.addListener(() => setState(() {}));

    errorMessage = null;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    insetPadding: const EdgeInsets.all(10),
                    title: const Text(
                      "Add a new account",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF072E08),
                      ),
                    ),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.18,
                      child: Center(
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            labelText: 'Account Name',
                            labelStyle:
                                const TextStyle(color: Color(0xFF072E08)),
                            errorText: errorMessage,
                          ),
                          controller: _nameController,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _nameController.clear();
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
                            addAccount();
                            _nameController.clear();
                            ref.invalidate(accountsProvider);
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              errorMessage = 'Please enter a name';
                            });
                          }
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  );
                },
              );
            });
      },
      child: Card(
        elevation: 0,
        color: const Color.fromARGB(255, 142, 142, 142),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Future<void> addAccount() async {
    await Supabase.instance.client.from('accounts').insert([
      {
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'name': _nameController.text,
        'created_at': DateTime.now().toIso8601String(),
      }
    ]).then((value) {
      ref.invalidate(accountsProvider);
    }).catchError((error) {
      print(error);
    });
  }

  bool validateName() {
    if (_nameController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
