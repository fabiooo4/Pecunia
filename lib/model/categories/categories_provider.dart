import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/api/categories/categories_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'category.dart';

part 'categories_provider.g.dart';

@riverpod
Future<List<Category>> categories(
  CategoriesRef ref,
) {
  return ref.read(categoriesRepositoryProvider).getCategories();
}
