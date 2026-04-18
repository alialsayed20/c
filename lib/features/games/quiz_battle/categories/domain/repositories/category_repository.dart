import '../models/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();

  Future<List<Category>> getCategoriesByIds(List<String> ids);
}