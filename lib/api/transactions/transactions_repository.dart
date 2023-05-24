import 'package:pecunia/model/transactions/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'transactions_repository.g.dart';

@riverpod
TransactionsRepository transactionsRepository(TransactionsRepositoryRef ref) =>
    TransactionsRepository();

class TransactionsRepository {
  final client = Supabase.instance.client;
  final List<Transaction> result = [];

  Future<List<Transaction>> getTransactions() async {
    final data = await client
        .from('transactions')
        .select()
        .eq("user_id", client.auth.currentUser!.id);
    data.forEach((element) {
      result.add(Transaction.fromJson(element));
    });
    return result;
  }

  Future<Transaction> getTransaction(String id) async {
    final data = await client
        .from('transactions')
        .select()
        .eq("user_id", client.auth.currentUser!.id)
        .eq("id", id)
        .single();
    return Transaction.fromJson(data);
  }
}
