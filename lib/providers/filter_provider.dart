import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

enum RecipeSortOption {
  createdAtDesc,    // 최신순 (기본값)
  createdAtAsc,     // 오래된 순
  nameAsc,          // 이름 오름차순 (가나다)
  nameDesc,         // 이름 내림차순 (하마바)
  cookingTimeAsc,   // 조리 시간 짧은 순
  cookingTimeDesc,  // 조리 시간 긴 순
  difficultyAsc,    // 난이도 낮은 순 (쉬움 → 어려움)
  difficultyDesc,   // 난이도 높은 순 (어려움 → 쉬움)
}

class RecipeFilterState {
  final List<String> categories;
  final List<String> tags;
  final bool favoriteOnly;
  final String searchQuery;
  final RecipeSortOption sortBy;

  const RecipeFilterState({
    this.categories = const [],
    this.tags = const [],
    this.favoriteOnly = false,
    this.searchQuery = '',
    this.sortBy = RecipeSortOption.createdAtDesc,
  });

  bool get isActive =>
      categories.isNotEmpty ||
      tags.isNotEmpty ||
      favoriteOnly ||
      searchQuery.isNotEmpty ||
      sortBy != RecipeSortOption.createdAtDesc;

  RecipeFilterState copyWith({
    List<String>? categories,
    List<String>? tags,
    bool? favoriteOnly,
    String? searchQuery,
    RecipeSortOption? sortBy,
  }) {
    return RecipeFilterState(
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      favoriteOnly: favoriteOnly ?? this.favoriteOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  static const empty = RecipeFilterState();
}

@riverpod
class RecipeFilter extends _$RecipeFilter {
  @override
  RecipeFilterState build() {
    return RecipeFilterState.empty;
  }

  void setCategories(List<String> categories) {
    state = state.copyWith(categories: categories);
  }

  void setTags(List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  void setFavoriteOnly(bool favoriteOnly) {
    state = state.copyWith(favoriteOnly: favoriteOnly);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortBy(RecipeSortOption sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void clearFilters() {
    state = RecipeFilterState.empty;
  }
}
