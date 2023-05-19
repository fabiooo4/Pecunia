
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pecunia/model/users/user.dart';

part 'users_repository.g.dart';

@riverpod
UsersRepository usersRepository(UsersRepositoryRef ref) => UsersRepository();

class UsersRepository {
  final client = Supabase.instance.client;
  Future<UserModel> getUser(String id) async {
    final data = await client.from('users').select().eq('id', id);
    return UserModel(
      id: data[0]['id'],
      username: data[0]['username'],
    );
  }
}