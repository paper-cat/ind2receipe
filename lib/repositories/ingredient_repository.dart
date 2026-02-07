import 'package:isar/isar.dart';
import 'package:idg2recipes/models/ingredient.dart';
import 'package:idg2recipes/models/recipe.dart';

class IngredientRepository {
  final Isar isar;

  IngredientRepository(this.isar);

  // 재료명 정규화
  String normalizeIngredientName(String name) {
    return name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }

  // 재료 생성 또는 가져오기
  Future<Ingredient> getOrCreateIngredient(String displayName) async {
    final normalized = normalizeIngredientName(displayName);

    // 기존 재료 찾기
    final existing = await isar.ingredients
        .where()
        .normalizedNameEqualTo(normalized)
        .findFirst();

    if (existing != null) {
      return existing;
    }

    // 새 재료 생성
    final ingredient = Ingredient()
      ..normalizedName = normalized
      ..displayName = displayName
      ..usageCount = 0
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.ingredients.put(ingredient);
    });

    return ingredient;
  }

  // 재료 검색 (자동완성용)
  Future<List<Ingredient>> searchIngredients(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final normalized = normalizeIngredientName(query);

    final results = await isar.ingredients
        .where()
        .filter()
        .normalizedNameContains(normalized)
        .sortByUsageCountDesc()
        .limit(20)
        .findAll();

    return results;
  }

  // 전체 재료 목록
  Future<List<Ingredient>> getAllIngredients() async {
    return await isar.ingredients.where().sortByDisplayName().findAll();
  }

  // 재료 사용 횟수 증가
  Future<void> incrementUsageCount(String normalizedName) async {
    final ingredient = await isar.ingredients
        .where()
        .normalizedNameEqualTo(normalizedName)
        .findFirst();

    if (ingredient != null) {
      await isar.writeTxn(() async {
        ingredient.usageCount++;
        ingredient.updatedAt = DateTime.now();
        await isar.ingredients.put(ingredient);
      });
    }
  }

  // 재료 사용 횟수 감소
  Future<void> decrementUsageCount(String normalizedName) async {
    final ingredient = await isar.ingredients
        .where()
        .normalizedNameEqualTo(normalizedName)
        .findFirst();

    if (ingredient != null && ingredient.usageCount > 0) {
      await isar.writeTxn(() async {
        ingredient.usageCount--;
        ingredient.updatedAt = DateTime.now();
        await isar.ingredients.put(ingredient);
      });
    }
  }

  // usageCount 내림차순으로 전체 재료 목록 Stream
  Stream<List<Ingredient>> watchAllIngredientsByUsage() {
    return isar.ingredients
        .where()
        .sortByUsageCountDesc()
        .watch(fireImmediately: true);
  }

  // 재료 수정
  Future<void> updateIngredient(Ingredient ingredient) async {
    ingredient.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.ingredients.put(ingredient);
    });
  }

  // 재료 삭제
  Future<void> deleteIngredient(int id) async {
    await isar.writeTxn(() async {
      await isar.ingredients.delete(id);
    });
  }

  // 여러 재료 일괄 삭제 + 레시피 동기화
  Future<void> deleteIngredientsAndUpdateRecipes(List<int> ids) async {
    final normalizedNames = <String>[];

    // 1. 삭제할 재료의 normalizedName 수집
    for (final id in ids) {
      final ingredient = await isar.ingredients.get(id);
      if (ingredient != null) {
        normalizedNames.add(ingredient.normalizedName);
      }
    }

    // 2. 트랜잭션으로 원자성 보장
    await isar.writeTxn(() async {
      // 2-1. 해당 재료를 사용하는 모든 레시피에서 제거
      final allRecipes = await isar.recipes.where().findAll();
      for (final recipe in allRecipes) {
        final originalLength = recipe.ingredientIds.length;
        recipe.ingredientIds.removeWhere((id) => normalizedNames.contains(id));

        if (recipe.ingredientIds.length != originalLength) {
          // ingredientAmounts도 동기화
          if (recipe.ingredientAmounts.length > recipe.ingredientIds.length) {
            recipe.ingredientAmounts = recipe.ingredientAmounts
                .take(recipe.ingredientIds.length)
                .toList();
          }

          recipe.ingredientIdsIndex = recipe.ingredientIds;
          recipe.updatedAt = DateTime.now();
          await isar.recipes.put(recipe);
        }
      }

      // 2-2. 재료 삭제
      await isar.ingredients.deleteAll(ids);
    });
  }
}
