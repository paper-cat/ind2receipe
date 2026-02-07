import 'package:flutter/material.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/providers/filter_provider.dart';

class FilterDialog extends StatefulWidget {
  final List<String> initialCategories;
  final List<String> initialTags;
  final bool initialFavoriteOnly;
  final RecipeSortOption initialSortBy;
  final Function(List<String> categories, List<String> tags, bool favoriteOnly, RecipeSortOption sortBy) onApply;

  const FilterDialog({
    super.key,
    required this.initialCategories,
    required this.initialTags,
    required this.initialFavoriteOnly,
    required this.initialSortBy,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<String> _selectedCategories;
  late List<String> _selectedTags;
  late bool _favoriteOnly;
  late RecipeSortOption _sortBy;
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.initialCategories);
    _selectedTags = List.from(widget.initialTags);
    _favoriteOnly = widget.initialFavoriteOnly;
    _sortBy = widget.initialSortBy;
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        _tagController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleMedium = Theme.of(context).textTheme.titleMedium;

    return AlertDialog(
      title: const Text('필터'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 즐겨찾기 토글
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: _favoriteOnly ? Colors.amber : colorScheme.outline,
                ),
                const SizedBox(width: 12),
                Text('즐겨찾기만 보기', style: titleMedium),
                const Spacer(),
                Switch(
                  value: _favoriteOnly,
                  onChanged: (value) => setState(() => _favoriteOnly = value),
                ),
              ],
            ),
            const Divider(height: 32),
            // 정렬 섹션
            Text('정렬', style: titleMedium),
            const SizedBox(height: 12),
            DropdownButtonFormField<RecipeSortOption>(
              value: _sortBy,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sort),
              ),
              items: const [
                DropdownMenuItem(
                  value: RecipeSortOption.createdAtDesc,
                  child: Text('최신순'),
                ),
                DropdownMenuItem(
                  value: RecipeSortOption.createdAtAsc,
                  child: Text('오래된 순'),
                ),
                DropdownMenuItem(
                  value: RecipeSortOption.nameAsc,
                  child: Text('이름 오름차순 (가나다)'),
                ),
                DropdownMenuItem(
                  value: RecipeSortOption.nameDesc,
                  child: Text('이름 내림차순 (하마바)'),
                ),
                DropdownMenuItem(
                  value: RecipeSortOption.cookingTimeAsc,
                  child: Text('조리 시간 짧은 순'),
                ),
                DropdownMenuItem(
                  value: RecipeSortOption.cookingTimeDesc,
                  child: Text('조리 시간 긴 순'),
                ),
                DropdownMenuItem(
                  value: RecipeSortOption.difficultyAsc,
                  child: Text('난이도 낮은 순'),
                ),
                DropdownMenuItem(
                  value: RecipeSortOption.difficultyDesc,
                  child: Text('난이도 높은 순'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _sortBy = value);
                }
              },
            ),
            const Divider(height: 32),
            Text('카테고리', style: titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RecipeCategory.values.map((category) {
                final isSelected = _selectedCategories.contains(category.name);
                return FilterChip(
                  label: Text(category.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category.name);
                      } else {
                        _selectedCategories.remove(category.name);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('태그', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: '태그 추가',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTag,
                ),
              ),
              onSubmitted: (_) => _addTag(),
            ),
            if (_selectedTags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => setState(() => _selectedTags.remove(tag)),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            widget.onApply(_selectedCategories, _selectedTags, _favoriteOnly, _sortBy);
            Navigator.pop(context);
          },
          child: const Text('적용'),
        ),
      ],
    );
  }
}
