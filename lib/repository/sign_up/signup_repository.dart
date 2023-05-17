import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'signup_repository.g.dart';

@riverpod
SignUpRepository signUpRepository(_) => SignUpRepository();

class SignUpRepository {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp({required String email, required String password, required String username}) async {
    return _client.auth.signUp(email: email, password: password, data: {'username': username});
  }

}