import 'package:pecunia/api/accounts/accounts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'account.dart';

part 'accounts_provider.g.dart';

@riverpod
Future<List<Account>> accounts(
  AccountsRef ref,
) {
  return ref.read(accountsRepositoryProvider).getAccounts();
}
