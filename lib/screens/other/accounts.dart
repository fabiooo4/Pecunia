import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/accounts/account.dart';
import '../../model/accounts/accounts_provider.dart';
import '../../model/transactions/transaction.dart';
import '../../model/transactions/transactions_provider.dart';
import '../../widgets/account_tile.dart';
import '../../widgets/account_tile_add.dart';

class Accounts extends ConsumerStatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountList = ref.watch(accountsProvider);
    final transactionList = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Accounts',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: accountList.when(
                    data: (accountListdata) => accountListdata.length + 1,
                    loading: () => 0,
                    error: (error, stackTrace) => 0,
                  ),
                  controller: ScrollController(keepScrollOffset: false),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const AccountTileAdd();
                    }

                    final Account account = accountList.when(
                      data: (accountListdata) => accountListdata[index - 1],
                      loading: () => Account(
                        id: '',
                        name: '',
                      ),
                      error: (error, stackTrace) => Account(
                        id: '',
                        name: '',
                      ),
                    );

                    final List<Transaction> transactions = transactionList.when(
                      data: (transactionListdata) => transactionListdata
                          .where((element) => element.account == account.id)
                          .toList(),
                      loading: () => [],
                      error: (error, stackTrace) => [],
                    );

                    return AccountTile(
                      account: account,
                      transactions: transactions,
                      onTap: () {
                        null;
                      },
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
