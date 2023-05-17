import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

final authService = riverpod.Provider((ref) => AuthProvider());

final supabase = Supabase.instance.client;

class AuthProvider {
  Future signIn(email, password) async {
    if (email.isEmpty || password.isEmpty) {
      return null;
    }

    try {
      Object response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      return response;
    } on AuthException {
      return Error();
    }
  }

  Future signUp(username, email, password) async {
    final AuthResponse response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    ).catchError((e) => print(e));

    return response;
  }

  void signOut() {
    print('sign out');
  }

  void changePassword() {
    print('change password');
  }

  void verifyEmail() {
    print('verify email');
  }
}
