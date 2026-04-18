import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/local_category_repository.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';

final Provider<CategoryRepository> categoryRepositoryProvider =
    Provider<CategoryRepository>((ref) {
  return const LocalCategoryRepository();
});

final FutureProvider<List<Category>> availableCategoriesProvider =
    FutureProvider<List<Category>>((Ref ref) async {
  final CategoryRepository repository = ref.read(categoryRepositoryProvider);
  return repository.getAllCategories();
});