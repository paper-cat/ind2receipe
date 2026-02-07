import 'package:isar/isar.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/providers/filter_provider.dart';

class RecipeRepository {
  final Isar isar;

  RecipeRepository(this.isar);

  // 레시피 생성
  Future<Recipe> createRecipe(Recipe recipe) async {
    recipe.createdAt = DateTime.now();
    recipe.updatedAt = DateTime.now();
    recipe.ingredientIdsIndex = recipe.ingredientIds;
    recipe.categoriesIndex = recipe.categories;
    recipe.tagsIndex = recipe.tags;

    await isar.writeTxn(() async {
      await isar.recipes.put(recipe);
    });

    return recipe;
  }

  // 레시피 수정
  Future<Recipe> updateRecipe(Recipe recipe) async {
    recipe.updatedAt = DateTime.now();
    recipe.ingredientIdsIndex = recipe.ingredientIds;
    recipe.categoriesIndex = recipe.categories;
    recipe.tagsIndex = recipe.tags;

    await isar.writeTxn(() async {
      await isar.recipes.put(recipe);
    });

    return recipe;
  }

  // 레시피 삭제
  Future<void> deleteRecipe(int id) async {
    await isar.writeTxn(() async {
      await isar.recipes.delete(id);
    });
  }

  // 여러 레시피 일괄 삭제
  Future<void> deleteRecipes(List<int> ids) async {
    await isar.writeTxn(() async {
      await isar.recipes.deleteAll(ids);
    });
  }

  // 레시피 조회
  Future<Recipe?> getRecipe(int id) async {
    return await isar.recipes.get(id);
  }

  // 전체 레시피 목록
  Future<List<Recipe>> getAllRecipes() async {
    return await isar.recipes.where().sortByCreatedAtDesc().findAll();
  }

  // 전체 레시피 목록 (Stream)
  Stream<List<Recipe>> watchAllRecipes() {
    return isar.recipes.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  // 재료 기반 검색
  Future<List<Recipe>> findRecipesByIngredients(
    List<String> availableIngredientIds,
  ) async {
    print('🔍 [SEARCH] 시작: $availableIngredientIds');

    if (availableIngredientIds.isEmpty) {
      print('🔍 [SEARCH] 빈 배열 - 즉시 반환');
      return [];
    }

    print('🔍 [SEARCH] 전체 레시피 가져오기 (메모리 필터링 방식)...');

    // 전체 레시피를 가져와서 메모리에서 필터링 (Isar 쿼리 크래시 방지)
    final allRecipes = await isar.recipes.where().sortByCreatedAtDesc().findAll();
    print('🔍 [SEARCH] 총 ${allRecipes.length}개 레시피 로드됨');

    // 1단계: 최소 1개 이상 재료가 일치하는 레시피 찾기
    final candidates = allRecipes.where((recipe) {
      // 빈 재료 레시피 필터링
      if (recipe.ingredientIds.isEmpty) {
        print('⚠️ [SEARCH] 건너뜀: ${recipe.name} (재료 없음)');
        return false;
      }

      final hasMatch = recipe.ingredientIds.any((id) =>
        availableIngredientIds.contains(id)
      );
      if (hasMatch) {
        print('🔍 [SEARCH] 매칭: ${recipe.name} (재료: ${recipe.ingredientIds})');
      }
      return hasMatch;
    }).toList();

    print('🔍 [SEARCH] 최종 후보: ${candidates.length}개');

    // 2단계: 메모리에서 매칭률 계산 및 정렬
    candidates.sort((a, b) {
      // 추가 안전장치 (이미 필터링되었지만 이중 체크)
      if (a.ingredientIds.isEmpty) return 1;
      if (b.ingredientIds.isEmpty) return -1;

      final aMatchCount = a.ingredientIds
          .where((id) => availableIngredientIds.contains(id))
          .length;
      final bMatchCount = b.ingredientIds
          .where((id) => availableIngredientIds.contains(id))
          .length;

      final aMatchRate = aMatchCount / a.ingredientIds.length;  // 이제 안전
      final bMatchRate = bMatchCount / b.ingredientIds.length;  // 이제 안전

      // 완전 일치 우선, 이후 매칭률 내림차순
      if (aMatchRate == 1.0 && bMatchRate != 1.0) return -1;
      if (bMatchRate == 1.0 && aMatchRate != 1.0) return 1;
      return bMatchRate.compareTo(aMatchRate);
    });

    print('🔍 [SEARCH] 정렬 완료 - 반환');
    return candidates;
  }

  // 레시피 이름으로 검색
  Future<List<Recipe>> searchRecipesByName(String query) async {
    if (query.isEmpty) {
      return getAllRecipes();
    }

    final allRecipes = await getAllRecipes();
    final lowerQuery = query.toLowerCase();

    return allRecipes
        .where((recipe) => recipe.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // 카테고리 필터링
  Future<List<Recipe>> findRecipesByCategories(List<String> categories) async {
    if (categories.isEmpty) {
      return getAllRecipes();
    }

    final candidateIds = <int>{};
    for (final category in categories) {
      final recipes = await isar.recipes
          .filter()
          .categoriesIndexElementEqualTo(category)
          .findAll();
      candidateIds.addAll(recipes.map((r) => r.id));
    }

    final results = await isar.recipes.getAll(candidateIds.toList());
    return results.whereType<Recipe>().toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // 태그 필터링
  Future<List<Recipe>> findRecipesByTags(List<String> tags) async {
    if (tags.isEmpty) {
      return getAllRecipes();
    }

    final candidateIds = <int>{};
    for (final tag in tags) {
      final recipes = await isar.recipes
          .filter()
          .tagsIndexElementEqualTo(tag)
          .findAll();
      candidateIds.addAll(recipes.map((r) => r.id));
    }

    final results = await isar.recipes.getAll(candidateIds.toList());
    return results.whereType<Recipe>().toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // 즐겨찾기 토글
  Future<Recipe> toggleFavorite(int id) async {
    final recipe = await isar.recipes.get(id);
    if (recipe == null) throw Exception('레시피를 찾을 수 없습니다');

    recipe.isFavorite = !recipe.isFavorite;
    recipe.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.recipes.put(recipe);
    });

    return recipe;
  }

  // 즐겨찾기 레시피 목록 (Future)
  Future<List<Recipe>> getFavoriteRecipes() async {
    return await isar.recipes
        .filter()
        .isFavoriteEqualTo(true)
        .sortByCreatedAtDesc()
        .findAll();
  }

  // 즐겨찾기 레시피 목록 (Stream)
  Stream<List<Recipe>> watchFavoriteRecipes() {
    return isar.recipes
        .filter()
        .isFavoriteEqualTo(true)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  // 혼합 필터링 (카테고리 OR 태그 + 즐겨찾기 + 검색 + 정렬)
  Future<List<Recipe>> findRecipesByFilters({
    List<String>? categories,
    List<String>? tags,
    bool? favoriteOnly,
    String? searchQuery,
    RecipeSortOption? sortBy,
  }) async {
    final hasCategories = categories != null && categories.isNotEmpty;
    final hasTags = tags != null && tags.isNotEmpty;
    final hasFavoriteFilter = favoriteOnly == true;
    final hasSearchQuery = searchQuery != null && searchQuery.isNotEmpty;

    // 필터가 없으면 전체 목록을 가져와서 정렬만 적용
    List<Recipe> results;

    if (!hasCategories && !hasTags && !hasFavoriteFilter && !hasSearchQuery) {
      results = await getAllRecipes();
    } else {
      final candidateIds = <int>{};

      // 카테고리 필터
      if (hasCategories) {
        for (final category in categories) {
          final recipes = await isar.recipes
              .filter()
              .categoriesIndexElementEqualTo(category)
              .findAll();
          candidateIds.addAll(recipes.map((r) => r.id));
        }
      }

      // 태그 필터
      if (hasTags) {
        for (final tag in tags) {
          final recipes = await isar.recipes
              .filter()
              .tagsIndexElementEqualTo(tag)
              .findAll();
          candidateIds.addAll(recipes.map((r) => r.id));
        }
      }

      // 카테고리/태그가 없고 즐겨찾기만 필터링하는 경우
      if (!hasCategories && !hasTags && hasFavoriteFilter) {
        results = await getFavoriteRecipes();
      } else if (candidateIds.isNotEmpty) {
        // 결과 조회
        final resultsNullable = await isar.recipes.getAll(candidateIds.toList());
        results = resultsNullable.whereType<Recipe>().toList();

        // 즐겨찾기 필터 적용 (메모리 필터링)
        if (hasFavoriteFilter) {
          results = results.where((r) => r.isFavorite).toList();
        }
      } else {
        // 카테고리/태그는 있지만 후보가 없는 경우
        results = [];
      }
    }

    // 검색 쿼리 필터링 (이름, 설명, 태그에서 검색)
    if (hasSearchQuery) {
      final lowerQuery = searchQuery.toLowerCase();
      results = results.where((recipe) {
        final nameMatch = recipe.name.toLowerCase().contains(lowerQuery);
        final descMatch = recipe.description?.toLowerCase().contains(lowerQuery) ?? false;
        final tagMatch = recipe.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        return nameMatch || descMatch || tagMatch;
      }).toList();
    }

    // 정렬 로직
    final sortOption = sortBy ?? RecipeSortOption.createdAtDesc;
    results.sort((a, b) {
      // 즐겨찾기 우선 정렬 (항상 적용)
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;

      // 선택된 정렬 옵션 적용
      switch (sortOption) {
        case RecipeSortOption.createdAtDesc:
          return b.createdAt.compareTo(a.createdAt);
        case RecipeSortOption.createdAtAsc:
          return a.createdAt.compareTo(b.createdAt);
        case RecipeSortOption.nameAsc:
          return a.name.compareTo(b.name);
        case RecipeSortOption.nameDesc:
          return b.name.compareTo(a.name);
        case RecipeSortOption.cookingTimeAsc:
          final aTime = a.cookingTimeMinutes ?? 999;
          final bTime = b.cookingTimeMinutes ?? 999;
          return aTime.compareTo(bTime);
        case RecipeSortOption.cookingTimeDesc:
          final aTime = a.cookingTimeMinutes ?? 0;
          final bTime = b.cookingTimeMinutes ?? 0;
          return bTime.compareTo(aTime);
        case RecipeSortOption.difficultyAsc:
          return a.difficulty.index.compareTo(b.difficulty.index);
        case RecipeSortOption.difficultyDesc:
          return b.difficulty.index.compareTo(a.difficulty.index);
      }
    });

    return results;
  }

  // Stream 버전
  Stream<List<Recipe>> watchRecipesByFilters({
    List<String>? categories,
    List<String>? tags,
    bool? favoriteOnly,
    String? searchQuery,
    RecipeSortOption? sortBy,
  }) async* {
    yield await findRecipesByFilters(
      categories: categories,
      tags: tags,
      favoriteOnly: favoriteOnly,
      searchQuery: searchQuery,
      sortBy: sortBy,
    );

    await for (final _ in isar.recipes.watchLazy()) {
      yield await findRecipesByFilters(
        categories: categories,
        tags: tags,
        favoriteOnly: favoriteOnly,
        searchQuery: searchQuery,
        sortBy: sortBy,
      );
    }
  }
}
