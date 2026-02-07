import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/providers/recipe_provider.dart';
import 'package:idg2recipes/providers/filter_provider.dart';
import 'package:idg2recipes/screens/recipe_detail/recipe_detail_screen.dart';
import 'package:idg2recipes/screens/recipe_form/recipe_form_screen.dart';
import 'package:idg2recipes/screens/ingredient_search/ingredient_search_screen.dart';
import 'package:idg2recipes/widgets/recipe_card.dart';
import 'package:idg2recipes/widgets/filter_dialog.dart';
import 'package:idg2recipes/widgets/empty_state.dart';
import 'package:idg2recipes/widgets/animated_fab.dart';
import 'package:idg2recipes/widgets/loading_indicator.dart';
import 'package:idg2recipes/utils/page_transitions.dart';
import 'package:idg2recipes/theme/app_theme.dart';
import 'package:idg2recipes/models/recipe.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSearchMode = false;
  bool _isSelectionMode = false;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(recipeFilterProvider.notifier).setSearchQuery(query);
    });
  }

  void _enterSelectionMode(int firstSelectedId) {
    setState(() => _isSelectionMode = true);
    ref.read(selectedRecipesProvider.notifier).toggle(firstSelectedId);
  }

  void _exitSelectionMode() {
    setState(() => _isSelectionMode = false);
    ref.read(selectedRecipesProvider.notifier).clear();
  }

  Future<void> _confirmBulkDelete() async {
    final selectedIds = ref.read(selectedRecipesProvider);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일괄 삭제'),
        content: Text('${selectedIds.length}개의 레시피를 삭제하시겠습니까?'),
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
      await ref.read(recipeActionsProvider.notifier).deleteRecipes(selectedIds.toList());
      _exitSelectionMode();
    }
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    final currentFilter = ref.read(recipeFilterProvider);

    await showDialog(
      context: context,
      builder: (context) => FilterDialog(
        initialCategories: currentFilter.categories,
        initialTags: currentFilter.tags,
        initialFavoriteOnly: currentFilter.favoriteOnly,
        initialSortBy: currentFilter.sortBy,
        onApply: (categories, tags, favoriteOnly, sortBy) {
          ref.read(recipeFilterProvider.notifier).setCategories(categories);
          ref.read(recipeFilterProvider.notifier).setTags(tags);
          ref.read(recipeFilterProvider.notifier).setFavoriteOnly(favoriteOnly);
          ref.read(recipeFilterProvider.notifier).setSortBy(sortBy);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(filteredRecipesProvider);
    final filter = ref.watch(recipeFilterProvider);
    final selectedRecipes = ref.watch(selectedRecipesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectionMode,
              )
            : null,
        title: _isSelectionMode
            ? Text('${selectedRecipes.length}개 선택됨')
            : _isSearchMode
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: const InputDecoration(
                      hintText: '레시피 검색...',
                      border: InputBorder.none,
                    ),
                    onChanged: _onSearchChanged,
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 26,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Text('레시피'),
                    ],
                  ),
        actions: _isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    recipesAsync.whenData((recipes) {
                      ref
                          .read(selectedRecipesProvider.notifier)
                          .selectAll(recipes.map((r) => r.id).toList());
                    });
                  },
                  tooltip: '전체 선택',
                ),
              ]
            : [
                IconButton(
                  icon: Icon(_isSearchMode ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearchMode = !_isSearchMode;
                      if (!_isSearchMode) {
                        _searchController.clear();
                        ref.read(recipeFilterProvider.notifier).setSearchQuery('');
                      }
                    });
                  },
                  tooltip: _isSearchMode ? '검색 닫기' : '검색',
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterDialog(context),
                  tooltip: '필터',
                ),
                IconButton(
                  icon: const Icon(Icons.kitchen),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IngredientSearchScreen(),
                      ),
                    );
                  },
                  tooltip: '재료로 검색',
                ),
              ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 활성 필터 표시
              if (filter.isActive && !_isSelectionMode) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.filter_list, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            '필터 활성',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () =>
                                ref.read(recipeFilterProvider.notifier).clearFilters(),
                            child: const Text('초기화'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // 즐겨찾기 칩
                          if (filter.favoriteOnly)
                            Chip(
                              avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                              label: const Text('즐겨찾기'),
                              backgroundColor: Colors.amber.withOpacity(0.15),
                            ),
                          // 카테고리 칩들
                          ...filter.categories.map((categoryName) {
                            final category = RecipeCategory.values
                                .firstWhere((c) => c.name == categoryName);
                            return Chip(
                              label: Text(category.displayName),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                            );
                          }),
                          // 태그 칩들
                          ...filter.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              avatar: const Icon(Icons.tag, size: 16),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondaryContainer,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              // 레시피 목록
              Expanded(
                child: recipesAsync.when(
                  data: (recipes) {
                    if (recipes.isEmpty) {
                      return EmptyState(
                        icon: filter.isActive
                            ? Icons.search_off
                            : Icons.restaurant_menu,
                        iconColor: filter.isActive
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.primary,
                        title: filter.isActive
                            ? '필터 조건에 맞는 레시피가 없습니다'
                            : '등록된 레시피가 없습니다',
                        subtitle: filter.isActive
                            ? null
                            : '+ 버튼을 눌러 레시피를 추가해보세요',
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.listPadding),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          isSelectable: _isSelectionMode,
                          isSelected: selectedRecipes.contains(recipe.id),
                          onSelectChanged: (_) {
                            ref.read(selectedRecipesProvider.notifier).toggle(recipe.id);
                          },
                          onTap: _isSelectionMode
                              ? () {
                                  ref.read(selectedRecipesProvider.notifier).toggle(recipe.id);
                                }
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetailScreen(recipeId: recipe.id),
                                    ),
                                  );
                                },
                          onLongPress: !_isSelectionMode
                              ? () => _enterSelectionMode(recipe.id)
                              : null,
                        );
                      },
                    );
                  },
                  loading: () => const CustomLoadingIndicator(
                    message: '레시피를 불러오는 중...',
                  ),
                  error: (error, stack) => Center(child: Text('오류 발생: $error')),
                ),
              ),
            ],
          ),
          // 일괄 삭제 버튼
          if (_isSelectionMode && selectedRecipes.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: FilledButton.icon(
                icon: const Icon(Icons.delete),
                label: Text('${selectedRecipes.length}개 삭제'),
                onPressed: _confirmBulkDelete,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: AnimatedFAB(
        heroTag: 'home_fab',
        onPressed: () {
          Navigator.push(
            context,
            SlideUpPageRoute(
              builder: (context) => const RecipeFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
