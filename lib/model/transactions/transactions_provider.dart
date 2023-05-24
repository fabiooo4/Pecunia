import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pecunia/api/transactions/transactions_repository.dart';
import 'transaction.dart';

part 'transactions_provider.g.dart';

@riverpod
Future<List<Transaction>> transactions(
  TransactionsRef ref,
) {
  // return ref.read(transactionsRepositoryProvider).getTransactions();
  // return all the functions from the repository
  return ref.read(transactionsRepositoryProvider).getTransactions();
}

@riverpod
Future<Transaction> transaction(
  TransactionsRef ref,
  String id,
) {
  return ref.read(transactionsRepositoryProvider).getTransaction(id);
}
