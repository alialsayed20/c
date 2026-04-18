import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';

class LocalCategoryRepository implements CategoryRepository {
  const LocalCategoryRepository();

  static const List<Category> _categories = <Category>[
    Category(
      id: 'geography',
      title: 'Geography',
      icon: '🌍',
    ),
    Category(
      id: 'science',
      title: 'Science',
      icon: '🧪',
    ),
    Category(
      id: 'history',
      title: 'History',
      icon: '🏛️',
    ),
    Category(
      id: 'sports',
      title: 'Sports',
      icon: '⚽',
    ),
    Category(
      id: 'general',
      title: 'General',
      icon: '🎯',
    ),
    Category(
      id: 'movies',
      title: 'Movies',
      icon: '🎬',
    ),
    Category(
      id: 'music',
      title: 'Music',
      icon: '🎵',
    ),
    Category(
      id: 'technology',
      title: 'Technology',
      icon: '💻',
    ),
    Category(
      id: 'animals',
      title: 'Animals',
      icon: '🦁',
    ),
    Category(
      id: 'food',
      title: 'Food',
      icon: '🍔',
    ),
  ];

  @override
  Future<List<Category>> getAllCategories() async {
    return List<Category>.unmodifiable(_categories);
  }

  @override
  Future<List<Category>> getCategoriesByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return const <Category>[];
    }

    final Map<String, Category> categoriesById = <String, Category>{
      for (final Category category in _categories) category.id: category,
    };

    final List<Category> result = <Category>[];

    for (final String id in ids) {
      final Category? category = categoriesById[id];

      if (category == null) {
        throw StateError('Category not found for id: $id');
      }

      result.add(category);
    }

    return List<Category>.unmodifiable(result);
  }
}