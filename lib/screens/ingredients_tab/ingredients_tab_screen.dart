import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/models/ingredient.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/providers/ingredient_provider.dart';
import 'package:idg2recipes/screens/recipe_detail/recipe_detail_screen.dart';
import 'package:idg2recipes/widgets/recipe_card.dart';
import 'package:idg2recipes/widgets/ingredient_form_dialog.dart';
import 'package:idg2recipes/widgets/empty_state.dart';
import 'package:idg2recipes/widgets/animated_fab.dart';
import 'package:idg2recipes/widgets/loading_indicator.dart';
import 'package:idg2recipes/theme/app_theme.dart';

class IngredientsTabScreen extends ConsumerStatefulWidget {
  const IngredientsTabScreen({super.key});

  @override
  ConsumerState<IngredientsTabScreen> createState() =>
      _IngredientsTabScreenState();
}

class _IngredientsTabScreenState extends ConsumerState<IngredientsTabScreen> {
  bool _isSelectionMode = false;

  void _enterSelectionMode(int firstSelectedId) {
    setState(() => _isSelectionMode = true);
    ref.read(selectedIngredientIdsProvider.notifier).toggle(firstSelectedId);
  }

  void _exitSelectionMode() {
    setState(() => _isSelectionMode = false);
    ref.read(selectedIngredientIdsProvider.notifier).clear();
  }

  Future<void> _confirmBulkDelete() async {
    final selectedIds = ref.read(selectedIngredientIdsProvider);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일괄 삭제'),
        content: Text('${selectedIds.length}개의 재료를 삭제하시겠습니까?\n\n⚠️ 이 재료를 사용하는 레시피도 함께 업데이트됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(ingredientActionsProvider.notifier)
          .deleteIngredientsAndUpdateRecipes(selectedIds.toList());
      _exitSelectionMode();
    }
  }

  Future<void> _showAddIngredientDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const IngredientFormDialog(),
    );

    if (result != null && mounted) {
      await ref.read(ingredientActionsProvider.notifier).createIngredient(result);
    }
  }

  Future<void> _showEditIngredientDialog(Ingredient ingredient) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => IngredientFormDialog(
        initialIngredient: ingredient,
      ),
    );

    if (result != null && mounted) {
      final repository = await ref.read(ingredientRepositoryProvider.future);
      final updated = Ingredient()
        ..id = ingredient.id
        ..normalizedName = repository.normalizeIngredientName(result)
        ..displayName = result
        ..usageCount = ingredient.usageCount
        ..createdAt = ingredient.createdAt
        ..updatedAt = DateTime.now();

      await ref.read(ingredientActionsProvider.notifier).updateIngredient(updated);
    }
  }

  Future<void> _confirmDeleteIngredient(Ingredient ingredient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('재료 삭제'),
        content: Text('${ingredient.displayName}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      if (ref.read(selectedIngredientProvider) == ingredient.normalizedName) {
        ref.read(selectedIngredientProvider.notifier).select(null);
      }
      await ref.read(ingredientActionsProvider.notifier).deleteIngredient(ingredient.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(allIngredientsProvider);
    final selectedIngredient = ref.watch(selectedIngredientProvider);
    final selectedIngredientIds = ref.watch(selectedIngredientIdsProvider);
    final selectedRecipesAsync = selectedIngredient != null && !_isSelectionMode
        ? ref.watch(recipesBySelectedIngredientProvider)
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectionMode,
              )
            : null,
        title: _isSelectionMode
            ? Text('${selectedIngredientIds.length}개 선택됨')
            : Row(
                children: [
                  Icon(
                    Icons.kitchen,
                    size: 26,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Text('재료'),
                ],
              ),
        actions: _isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    ingredientsAsync.whenData((ingredients) {
                      ref
                          .read(selectedIngredientIdsProvider.notifier)
                          .selectAll(ingredients.map((i) => i.id).toList());
                    });
                  },
                  tooltip: '전체 선택',
                ),
              ]
            : null,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.bug_report),
        //     onPressed: () async {
        //       print('🔧 [DEBUG] 데이터베이스 전체 스캔 시작');
        //
        //       final isar = await ref.read(isarProvider.future);
        //
        //       // 모든 레시피 확인
        //       final allRecipes = await isar.recipes.where().findAll();
        //       print('🔧 [DEBUG] 총 레시피 개수: ${allRecipes.length}');
        //
        //       for (final recipe in allRecipes) {
        //         print('🔧 [DEBUG] 레시피: ${recipe.name}');
        //         print('   - ID: ${recipe.id}');
        //         print('   - ingredientIds: ${recipe.ingredientIds}');
        //         print('   - ingredientIdsIndex: ${recipe.ingredientIdsIndex}');
        //         print('   - 타입: ${recipe.ingredientIds.runtimeType}');
        //       }
        //
        //       // 모든 재료 확인
        //       final allIngredients = await isar.ingredients.where().findAll();
        //       print('🔧 [DEBUG] 총 재료 개수: ${allIngredients.length}');
        //
        //       for (final ingredient in allIngredients) {
        //         print('🔧 [DEBUG] 재료: ${ingredient.displayName}');
        //         print('   - ID: ${ingredient.id}');
        //         print('   - normalizedName: "${ingredient.normalizedName}"');
        //       }
        //
        //       if (mounted) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(content: Text('콘솔 로그를 확인하세요')),
        //         );
        //       }
        //     },
        //   ),
        // ],
      ),
      body: ingredientsAsync.when(
        data: (ingredients) {
          // 재료가 없을 때는 전체 화면을 EmptyState로 표시
          if (ingredients.isEmpty) {
            return EmptyState(
              icon: Icons.kitchen,
              iconColor: Theme.of(context).colorScheme.primary,
              title: '등록된 재료가 없습니다',
              subtitle: '+ 버튼을 눌러 재료를 추가해보세요',
            );
          }

          // 재료가 있을 때는 기존 레이아웃
          return Stack(
            children: [
              Column(
                children: [
                  // 재료 목록
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = ingredients[index];
                        final isSelectedForSearch = selectedIngredient == ingredient.normalizedName && !_isSelectionMode;
                        final isSelectedForDelete = selectedIngredientIds.contains(ingredient.id);

                        return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      elevation: (isSelectedForSearch || isSelectedForDelete) ? 4 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: (isSelectedForSearch || isSelectedForDelete)
                            ? BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        selected: isSelectedForSearch || isSelectedForDelete,
                        leading: _isSelectionMode
                            ? Checkbox(
                                value: isSelectedForDelete,
                                onChanged: (_) {
                                  ref.read(selectedIngredientIdsProvider.notifier).toggle(ingredient.id);
                                },
                              )
                            : CircleAvatar(
                                backgroundColor: isSelectedForSearch
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.eco,
                                  color: isSelectedForSearch
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                        title: Text(
                          ingredient.displayName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          '사용 횟수: ${ingredient.usageCount}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: !_isSelectionMode
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                                      onPressed: () => _showEditIngredientDialog(ingredient),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, size: 20),
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                      onPressed: () => _confirmDeleteIngredient(ingredient),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                        onTap: _isSelectionMode
                            ? () {
                                ref.read(selectedIngredientIdsProvider.notifier).toggle(ingredient.id);
                              }
                            : () {
                                if (isSelectedForSearch) {
                                  ref.read(selectedIngredientProvider.notifier).select(null);
                                } else {
                                  ref.read(selectedIngredientProvider.notifier).select(ingredient.normalizedName);
                                }
                              },
                        onLongPress: !_isSelectionMode
                            ? () => _enterSelectionMode(ingredient.id)
                            : null,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                // 레시피 검색 결과
                Expanded(
                  flex: 3,
                  child: _buildRecipeResults(selectedRecipesAsync),
                ),
              ],
            ),
            // 일괄 삭제 버튼
            if (_isSelectionMode && selectedIngredientIds.isNotEmpty)
              Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: FilledButton.icon(
                icon: const Icon(Icons.delete),
                label: Text('${selectedIngredientIds.length}개 삭제'),
                onPressed: _confirmBulkDelete,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );
        },
        loading: () => const CustomLoadingIndicator(
          message: '재료를 불러오는 중...',
        ),
        error: (error, stack) {
          print('❌ [재료 목록] 에러 발생: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  '재료 목록을 불러올 수 없습니다',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '잠시 후 다시 시도해주세요',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('새로고침'),
                  onPressed: () {
                    ref.invalidate(allIngredientsProvider);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: AnimatedFAB(
        heroTag: 'ingredients_fab',
        onPressed: _showAddIngredientDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecipeResults(AsyncValue<List<Recipe>>? recipesAsync) {
    if (recipesAsync == null) {
      return EmptyState(
        icon: Icons.touch_app,
        iconColor: Theme.of(context).colorScheme.outline,
        title: '재료를 선택하면 레시피를 검색합니다',
      );
    }

    return recipesAsync.when(
      data: (recipes) {
        print('✅ [UI] 데이터 수신: ${recipes.length}개');
        if (recipes.isEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            iconColor: Theme.of(context).colorScheme.outline,
            title: '이 재료를 사용한 레시피가 없습니다',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.listPadding),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () {
        print('⏳ [UI] 로딩 중...');
        return const CustomLoadingIndicator(
          message: '레시피를 검색하는 중...',
        );
      },
      error: (error, stack) {
        print('❌ [레시피 검색] 에러 발생: $error');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '레시피 검색 중 오류가 발생했습니다',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '다른 재료를 선택하거나 다시 시도해주세요',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
                onPressed: () {
                  ref.read(selectedIngredientProvider.notifier).select(null);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
