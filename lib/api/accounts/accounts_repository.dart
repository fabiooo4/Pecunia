import 'package:pecunia/model/accounts/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'accounts_repository.g.dart';

@riverpod
AccountsRepository accountsRepository(AccountsRepositoryRef ref) =>
    AccountsRepository();

class AccountsRepository {
  final client = Supabase.instance.client;
  final List<Account> result = [];

  Future<List<Account>> getAccounts() async {
    final data = await client
        .from('accounts')
        .select()
        .eq("user_id", client.auth.currentUser!.id);
    data.forEach((element) {
      result.add(Account.fromJson(element));
    });
    return result;
  }
}
