import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/providers/recipe_provider.dart';
import 'package:idg2recipes/screens/recipe_form/recipe_form_screen.dart';
import 'package:idg2recipes/widgets/ingredient_chip.dart';
import 'package:idg2recipes/theme/app_theme.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final int recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
  });

  String _getDifficultyText(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy:
        return '쉬움';
      case DifficultyLevel.medium:
        return '보통';
      case DifficultyLevel.hard:
        return '어려움';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('레시피 상세'),
        actions: [
          // 즐겨찾기 버튼
          recipeAsync.when(
            data: (recipe) {
              if (recipe == null) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.star : Icons.star_border,
                  color: recipe.isFavorite ? Colors.amber : null,
                ),
                onPressed: () {
                  ref.read(recipeActionsProvider.notifier).toggleFavorite(recipeId);
                },
                tooltip: recipe.isFavorite ? '즐겨찾기 해제' : '즐겨찾기 추가',
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // 메뉴 버튼
          recipeAsync.when(
            data: (recipe) {
              if (recipe == null) return const SizedBox.shrink();
              return PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeFormScreen(recipe: recipe),
                      ),
                    );
                  } else if (value == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('삭제 확인'),
                        content: const Text('정말로 이 레시피를 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('삭제'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      await ref
                          .read(recipeActionsProvider.notifier)
                          .deleteRecipe(recipeId);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('수정'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('삭제'),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: recipeAsync.when(
        data: (recipe) {
          if (recipe == null) {
            return const Center(
              child: Text('레시피를 찾을 수 없습니다'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: AppTextStyles.detailTitle(context),
                ),
                if (recipe.description != null &&
                    recipe.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    recipe.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (recipe.cookingTimeMinutes != null) ...[
                      const Icon(Icons.access_time, size: 24),
                      const SizedBox(width: 6),
                      Text('${recipe.cookingTimeMinutes}분'),
                      const SizedBox(width: 20),
                    ],
                    if (recipe.servings != null) ...[
                      const Icon(Icons.people, size: 24),
                      const SizedBox(width: 6),
                      Text('${recipe.servings}인분'),
                      const SizedBox(width: 20),
                    ],
                    const Icon(Icons.signal_cellular_alt, size: 24),
                    const SizedBox(width: 6),
                    Text(_getDifficultyText(recipe.difficulty)),
                  ],
                ),
                if (recipe.categories.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    '카테고리',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recipe.categories.map((categoryName) {
                      final category = RecipeCategory.values.firstWhere(
                        (c) => c.name == categoryName,
                        orElse: () => RecipeCategory.korean,
                      );
                      return Chip(
                        label: Text(category.displayName),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      );
                    }).toList(),
                  ),
                ],
                if (recipe.tags.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    '태그',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recipe.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        avatar: const Icon(Icons.tag, size: 16),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: AppSpacing.xLarge),
                Text(
                  '재료',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    recipe.ingredientIds.length,
                    (index) {
                      final amount = index < recipe.ingredientAmounts.length
                          ? recipe.ingredientAmounts[index]
                          : '';
                      final label = amount.isNotEmpty
                          ? '${recipe.ingredientIds[index]} ($amount)'
                          : recipe.ingredientIds[index];
                      return IngredientChip(label: label);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '조리 방법',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  recipe.steps.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            recipe.steps[index],
                            style: AppTextStyles.stepText(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('오류 발생: $error'),
        ),
      ),
    );
  }
}
