import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/theme/app_theme.dart';
import 'package:idg2recipes/providers/recipe_provider.dart';

class RecipeCard extends ConsumerWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final bool isSelectable;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectChanged;
  final VoidCallback? onLongPress;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.isSelectable = false,
    this.isSelected = false,
    this.onSelectChanged,
    this.onLongPress,
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

  Color _getDifficultyColor(BuildContext context, DifficultyLevel level) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (level) {
      case DifficultyLevel.easy:
        return colorScheme.tertiary;
      case DifficultyLevel.medium:
        return colorScheme.secondary;
      case DifficultyLevel.hard:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardHorizontalMargin,
        vertical: AppSpacing.cardVerticalMargin,
      ),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorders.cardRadius),
        side: isSelected
            ? BorderSide(color: colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppBorders.cardRadius),
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 선택 모드일 때 체크박스 표시
              if (isSelectable) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 4),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectChanged,
                  ),
                ),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: AppTextStyles.cardTitle(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 선택 모드가 아닐 때만 즐겨찾기 버튼 표시
                        if (!isSelectable) ...[
                          // 즐겨찾기 아이콘
                          IconButton(
                            icon: Icon(
                              recipe.isFavorite ? Icons.star : Icons.star_border,
                              color: recipe.isFavorite ? Colors.amber : colorScheme.outline,
                              size: 24,
                            ),
                            onPressed: () {
                              ref.read(recipeActionsProvider.notifier).toggleFavorite(recipe.id);
                            },
                            tooltip: recipe.isFavorite ? '즐겨찾기 해제' : '즐겨찾기 추가',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 12),
                        ],
                        // 난이도 배지
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(context, recipe.difficulty)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getDifficultyText(recipe.difficulty),
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: _getDifficultyColor(context, recipe.difficulty),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    if (recipe.description != null && recipe.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        recipe.description!,
                        style: AppTextStyles.cardDescription(context),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (recipe.cookingTimeMinutes != null)
                          _MetadataChip(
                            icon: Icons.access_time,
                            label: '${recipe.cookingTimeMinutes}분',
                          ),
                        if (recipe.servings != null)
                          _MetadataChip(
                            icon: Icons.people,
                            label: '${recipe.servings}인분',
                          ),
                        _MetadataChip(
                          icon: Icons.restaurant,
                          label: '재료 ${recipe.ingredientIds.length}개',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetadataChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
