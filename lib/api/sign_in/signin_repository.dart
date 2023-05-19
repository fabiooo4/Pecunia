import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'signin_repository.g.dart';

@riverpod
SignInRepository signInRepository(_) => SignInRepository();


class SignInRepository {
  final _client = Supabase.instance.client;
  
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }
}