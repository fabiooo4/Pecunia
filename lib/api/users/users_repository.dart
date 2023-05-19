import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'users_repository.g.dart';

@riverpod
UsersRepository usersRepository(_) => UsersRepository();

class UsersRepository {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp({required String email, required String password, required String username}) async {
    return _client.auth.signUp(email: email, password: password, data: {'username': username});
  }
}