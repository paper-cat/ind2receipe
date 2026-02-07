import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:idg2recipes/models/ingredient.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/repositories/ingredient_repository.dart';
import 'package:idg2recipes/repositories/recipe_repository.dart';
import 'package:idg2recipes/providers/database_provider.dart';

part 'ingredient_provider.g.dart';

// Repository
@riverpod
Future<IngredientRepository> ingredientRepository(IngredientRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IngredientRepository(isar);
}

// 재료 검색 (자동완성)
@riverpod
Future<List<Ingredient>> searchIngredients(
  SearchIngredientsRef ref,
  String query,
) async {
  final repository = await ref.watch(ingredientRepositoryProvider.future);
  return repository.searchIngredients(query);
}

// 사용자 선택 재료 (로컬 상태)
@riverpod
class SelectedIngredients extends _$SelectedIngredients {
  @override
  List<String> build() => [];

  void addIngredient(String ingredientId) {
    if (!state.contains(ingredientId)) {
      state = [...state, ingredientId];
    }
  }

  void removeIngredient(String ingredientId) {
    state = state.where((id) => id != ingredientId).toList();
  }

  void clear() {
    state = [];
  }
}

// 선택된 재료 (단일)
@riverpod
class SelectedIngredient extends _$SelectedIngredient {
  @override
  String? build() => null;

  void select(String? normalizedName) {
    state = normalizedName;
  }
}

// 선택된 재료로 레시피 검색
@riverpod
Future<List<Recipe>> recipesBySelectedIngredient(
  RecipesBySelectedIngredientRef ref,
) async {
  final selectedIngredient = ref.watch(selectedIngredientProvider);

  print('📦 [PROVIDER] recipesBySelectedIngredient 호출됨');
  print('📦 [PROVIDER] 선택된 재료: $selectedIngredient');

  if (selectedIngredient == null) {
    print('📦 [PROVIDER] 선택 없음 - 즉시 반환');
    return [];
  }

  print('📦 [PROVIDER] Isar 가져오는 중...');
  final isar = await ref.watch(isarProvider.future);
  print('📦 [PROVIDER] Isar 획득 완료');

  print('📦 [PROVIDER] Repository 생성...');
  final repository = RecipeRepository(isar);

  print('📦 [PROVIDER] Repository.findRecipesByIngredients 호출...');
  final result = await repository.findRecipesByIngredients([selectedIngredient])
      .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('❌ [TIMEOUT] 5초 초과 - 빈 배열 반환');
          return <Recipe>[];
        },
      );

  print('📦 [PROVIDER] 결과 반환: ${result.length}개');
  return result;
}

// 선택된 재료로 레시피 검색 (리스트 버전 - 기존 호환성)
@riverpod
Future<List<Recipe>> recipesByIngredients(
  RecipesByIngredientsRef ref,
  List<String> ingredientIds,
) async {
  print('📦 [PROVIDER] recipesByIngredients 호출됨');
  print('📦 [PROVIDER] 파라미터: $ingredientIds');

  if (ingredientIds.isEmpty) {
    print('📦 [PROVIDER] 빈 배열 - 즉시 반환');
    return [];
  }

  print('📦 [PROVIDER] Isar 가져오는 중...');
  final isar = await ref.watch(isarProvider.future);
  print('📦 [PROVIDER] Isar 획득 완료');

  print('📦 [PROVIDER] Repository 생성...');
  final repository = RecipeRepository(isar);

  print('📦 [PROVIDER] Repository.findRecipesByIngredients 호출...');
  final result = await repository.findRecipesByIngredients(ingredientIds)
      .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('❌ [TIMEOUT] 5초 초과 - 빈 배열 반환');
          return <Recipe>[];
        },
      );

  print('📦 [PROVIDER] 결과 반환: ${result.length}개');
  return result;
}

// 전체 재료 목록 (usageCount 내림차순)
@riverpod
Stream<List<Ingredient>> allIngredients(AllIngredientsRef ref) async* {
  final repository = await ref.watch(ingredientRepositoryProvider.future);
  yield* repository.watchAllIngredientsByUsage();
}

// 다중 선택 재료 프로바이더 (재료 탭용)
@riverpod
class SelectedIngredientIds extends _$SelectedIngredientIds {
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

// 재료 CRUD Actions
@riverpod
class IngredientActions extends _$IngredientActions {
  @override
  FutureOr<void> build() {}

  Future<void> createIngredient(String displayName) async {
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(ingredientRepositoryProvider.future);
      await repository.getOrCreateIngredient(displayName);
    });
  }

  Future<void> updateIngredient(Ingredient ingredient) async {
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(ingredientRepositoryProvider.future);
      await repository.updateIngredient(ingredient);
    });
  }

  Future<void> deleteIngredient(int id) async {
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(ingredientRepositoryProvider.future);
      await repository.deleteIngredient(id);
    });
  }

  Future<void> deleteIngredientsAndUpdateRecipes(List<int> ids) async {
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(ingredientRepositoryProvider.future);
      await repository.deleteIngredientsAndUpdateRecipes(ids);
    });
  }
}
