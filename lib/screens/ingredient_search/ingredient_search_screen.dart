import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/models/ingredient.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/providers/ingredient_provider.dart';
import 'package:idg2recipes/screens/recipe_detail/recipe_detail_screen.dart';
import 'package:idg2recipes/widgets/ingredient_chip.dart';
import 'package:idg2recipes/widgets/recipe_card.dart';
import 'package:idg2recipes/widgets/empty_state.dart';
import 'package:idg2recipes/widgets/loading_indicator.dart';
import 'package:idg2recipes/theme/app_theme.dart';
import 'package:idg2recipes/theme/color_scheme.dart';

class IngredientSearchScreen extends ConsumerStatefulWidget {
  const IngredientSearchScreen({super.key});

  @override
  ConsumerState<IngredientSearchScreen> createState() =>
      _IngredientSearchScreenState();
}

class _IngredientSearchScreenState
    extends ConsumerState<IngredientSearchScreen> {
  final _searchController = TextEditingController();
  final List<String> _selectedIngredients = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addIngredient(String ingredientId) {
    if (!_selectedIngredients.contains(ingredientId)) {
      setState(() {
        _selectedIngredients.add(ingredientId);
      });
    }
    _searchController.clear();
  }

  void _removeIngredient(String ingredientId) {
    setState(() {
      _selectedIngredients.remove(ingredientId);
    });
  }

  String _getMatchRateText(Recipe recipe) {
    final matchCount = recipe.ingredientIds
        .where((id) => _selectedIngredients.contains(id))
        .length;
    final totalCount = recipe.ingredientIds.length;
    final matchRate = (matchCount / totalCount * 100).round();

    if (matchRate == 100) {
      return '✅ 만들 수 있어요!';
    } else {
      return '$matchRate% 일치 ($matchCount/$totalCount 재료)';
    }
  }

  Color _getMatchRateColor(BuildContext context, Recipe recipe) {
    final matchCount = recipe.ingredientIds
        .where((id) => _selectedIngredients.contains(id))
        .length;
    final totalCount = recipe.ingredientIds.length;
    final matchRate = matchCount / totalCount;

    if (matchRate == 1.0) {
      return AppColorScheme.success(context);
    } else if (matchRate >= 0.7) {
      return AppColorScheme.warning(context);
    } else {
      return Theme.of(context).colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = _searchController.text;
    final ingredientSearchAsync = searchQuery.isEmpty
        ? const AsyncValue<List<Ingredient>>.data([])
        : ref.watch(searchIngredientsProvider(searchQuery));

    final recipesAsync = _selectedIngredients.isEmpty
        ? const AsyncValue<List<Recipe>>.data([])
        : ref.watch(recipesByIngredientsProvider(_selectedIngredients));

    return Scaffold(
      appBar: AppBar(
        title: const Text('재료로 레시피 찾기'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: '보유 재료 검색',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                ingredientSearchAsync.when(
                  data: (ingredients) {
                    if (ingredients.isEmpty && searchQuery.isNotEmpty) {
                      return Card(
                        child: ListTile(
                          title: Text('새 재료: $searchQuery'),
                          trailing: const Icon(Icons.add),
                          onTap: () async {
                            final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);
                            final newIngredient = await ingredientRepo.getOrCreateIngredient(searchQuery);
                            _addIngredient(newIngredient.normalizedName);
                          },
                        ),
                      );
                    }
                    if (ingredients.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Card(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: ingredients.length + 1,
                        itemBuilder: (context, index) {
                          if (index == ingredients.length) {
                            return ListTile(
                              title: Text('새 재료: $searchQuery'),
                              trailing: const Icon(Icons.add),
                              onTap: () async {
                                final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);
                                final newIngredient = await ingredientRepo.getOrCreateIngredient(searchQuery);
                                _addIngredient(newIngredient.normalizedName);
                              },
                            );
                          }
                          final ingredient = ingredients[index];
                          return ListTile(
                            title: Text(ingredient.displayName),
                            trailing: const Icon(Icons.add),
                            onTap: () {
                              _addIngredient(ingredient.normalizedName);
                            },
                          );
                        },
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                ),
                if (_selectedIngredients.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    '선택된 재료 (${_selectedIngredients.length}개)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedIngredients.map((ingredientId) {
                      return IngredientChip(
                        label: ingredientId,
                        onDeleted: () => _removeIngredient(ingredientId),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 2, thickness: 1),
          Expanded(
            child: recipesAsync.when(
              data: (recipes) {
                if (_selectedIngredients.isEmpty) {
                  return EmptyState(
                    icon: Icons.restaurant,
                    iconColor: Theme.of(context).colorScheme.outline,
                    title: '보유한 재료를 선택해주세요',
                  );
                }

                if (recipes.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    iconColor: Theme.of(context).colorScheme.outline,
                    title: '만들 수 있는 레시피가 없습니다',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.listPadding),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    final matchRateColor = _getMatchRateColor(context, recipe);
                    final matchCount = recipe.ingredientIds
                        .where((id) => _selectedIngredients.contains(id))
                        .length;
                    final totalCount = recipe.ingredientIds.length;
                    final matchRate = matchCount / totalCount;
                    return Column(
                      children: [
                        RecipeCard(
                          recipe: recipe,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipeId: recipe.id),
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: matchRate == 1.0
                                ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                                : Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: matchRateColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getMatchRateText(recipe),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: matchRateColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const CustomLoadingIndicator(
                message: '레시피를 검색하는 중...',
              ),
              error: (error, stack) => Center(
                child: Text('오류 발생: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
