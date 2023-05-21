import 'package:pecunia/model/categories/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'categories_repository.g.dart';

@riverpod
CategoriesRepository categoriesRepository(CategoriesRepositoryRef ref) =>
    CategoriesRepository();

class CategoriesRepository {
  final client = Supabase.instance.client;
  final List<Category> result = [];

  Future<List<Category>> getCategories() async {
    final data = await client
        .from('categories')
        .select()
        .eq("account_id", client.auth.currentUser!.id);
    data.forEach((element) {
      result.add(Category.fromJson(element));
      });
    return result;
  }
}
