import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/repositories/recipe_repository.dart';
import 'package:idg2recipes/providers/database_provider.dart';
import 'package:idg2recipes/providers/filter_provider.dart';

part 'recipe_provider.g.dart';

// Repository
@riverpod
RecipeRepository recipeRepository(RecipeRepositoryRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return RecipeRepository(isar);
}

// 전체 레시피 목록 (Stream)
@riverpod
Stream<List<Recipe>> allRecipes(AllRecipesRef ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.watchAllRecipes();
}

// 레시피 상세 조회
@riverpod
Future<Recipe?> recipeDetail(RecipeDetailRef ref, int id) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getRecipe(id);
}

// 필터링된 레시피 목록 (Stream)
@riverpod
Stream<List<Recipe>> filteredRecipes(FilteredRecipesRef ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  final filter = ref.watch(recipeFilterProvider);

  if (!filter.isActive) {
    return repository.watchAllRecipes();
  }

  return repository.watchRecipesByFilters(
    categories: filter.categories,
    tags: filter.tags,
    favoriteOnly: filter.favoriteOnly,
    searchQuery: filter.searchQuery,
    sortBy: filter.sortBy,
  );
}

// 레시피 CRUD 액션
@riverpod
class RecipeActions extends _$RecipeActions {
  @override
  FutureOr<void> build() {}

  Future<void> createRecipe(Recipe recipe) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(recipeRepositoryProvider);
      await repository.createRecipe(recipe);
    });
  }

  Future<void> updateRecipe(Recipe recipe) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(recipeRepositoryProvider);
      await repository.updateRecipe(recipe);
    });
  }

  Future<void> deleteRecipe(int id) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(recipeRepositoryProvider);
      await repository.deleteRecipe(id);
    });
  }

  Future<void> deleteRecipes(List<int> ids) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(recipeRepositoryProvider);
      await repository.deleteRecipes(ids);
    });
  }

  Future<void> toggleFavorite(int id) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(recipeRepositoryProvider);
      await repository.toggleFavorite(id);
    });
  }
}

// 다중 선택 레시피 프로바이더
@riverpod
class SelectedRecipes extends _$SelectedRecipes {
  @override
  Set<int> build() => {};

  void toggle(int id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void selectAll(List<int> ids) {
    state = ids.toSet();
  }

  void clear() {
    state = {};
  }
}
