import 'package:pecunia/api/users/users_repository.dart';
import 'package:pecunia/model/users/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_provider.g.dart';

@riverpod
Future<UserModel> user(UserRef ref, {required String id,}) {
  return ref.watch(usersRepositoryProvider).getUser(id);
}