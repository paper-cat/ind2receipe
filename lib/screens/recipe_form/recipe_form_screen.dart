import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/models/ingredient.dart';
import 'package:idg2recipes/providers/recipe_provider.dart';
import 'package:idg2recipes/providers/ingredient_provider.dart';
import 'package:idg2recipes/widgets/ingredient_chip.dart';
import 'package:idg2recipes/widgets/ingredient_amount_field.dart';
import 'package:idg2recipes/widgets/ingredient_search_field.dart';
import 'package:idg2recipes/theme/app_theme.dart';

class RecipeFormScreen extends ConsumerStatefulWidget {
  final Recipe? recipe;

  const RecipeFormScreen({
    super.key,
    this.recipe,
  });

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servingsController = TextEditingController();
  final _cookingTimeController = TextEditingController();

  DifficultyLevel _difficulty = DifficultyLevel.medium;
  final List<String> _ingredientIds = [];
  final List<String> _ingredientDisplayNames = []; // displayName 저장용
  final List<String> _ingredientAmounts = [];
  final List<String> _steps = [];
  final List<String> _selectedCategories = [];
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _nameController.text = widget.recipe!.name;
      _descriptionController.text = widget.recipe!.description ?? '';
      _servingsController.text = widget.recipe!.servings?.toString() ?? '';
      _cookingTimeController.text =
          widget.recipe!.cookingTimeMinutes?.toString() ?? '';
      _difficulty = widget.recipe!.difficulty;
      _ingredientIds.addAll(widget.recipe!.ingredientIds);
      _ingredientAmounts.addAll(widget.recipe!.ingredientAmounts);
      _steps.addAll(widget.recipe!.steps);
      _selectedCategories.addAll(widget.recipe!.categories);
      _tags.addAll(widget.recipe!.tags);

      // displayNames 로드 (비동기 처리 필요)
      _loadIngredientDisplayNames();
    }
  }

  Future<void> _loadIngredientDisplayNames() async {
    // Repository 사용
    final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);
    final allIngredients = await ingredientRepo.getAllIngredients();

    for (final normalizedName in _ingredientIds) {
      // normalizedName으로 Ingredient 찾기
      final ingredient = allIngredients.firstWhere(
        (ing) => ing.normalizedName == normalizedName,
        orElse: () => Ingredient()
          ..normalizedName = normalizedName
          ..displayName = normalizedName,
      );

      setState(() {
        _ingredientDisplayNames.add(ingredient.displayName);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _servingsController.dispose();
    _cookingTimeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

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

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_ingredientIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('재료를 최소 1개 이상 추가해주세요')),
      );
      return;
    }

    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('조리 단계를 최소 1개 이상 추가해주세요')),
      );
      return;
    }

    // 확인 다이얼로그 표시
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.recipe == null ? '레시피 추가' : '레시피 수정'),
        content: Text(widget.recipe == null
            ? '레시피를 추가하시겠습니까?'
            : '레시피를 수정하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    final recipe = Recipe()
      ..name = _nameController.text
      ..description = _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text
      ..servings = _servingsController.text.isEmpty
          ? null
          : int.parse(_servingsController.text)
      ..cookingTimeMinutes = _cookingTimeController.text.isEmpty
          ? null
          : int.parse(_cookingTimeController.text)
      ..difficulty = _difficulty
      ..categories = _selectedCategories
      ..tags = _tags
      ..ingredientIds = _ingredientIds
      ..ingredientAmounts = _ingredientAmounts
      ..steps = _steps;

    if (widget.recipe != null) {
      recipe.id = widget.recipe!.id;
      recipe.createdAt = widget.recipe!.createdAt;
      await ref.read(recipeActionsProvider.notifier).updateRecipe(recipe);
    } else {
      await ref.read(recipeActionsProvider.notifier).createRecipe(recipe);
    }

    // 재료 사용 횟수 업데이트
    final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);
    for (final ingredientId in _ingredientIds) {
      await ingredientRepo.incrementUsageCount(ingredientId);
    }

    if (mounted) {
      if (widget.recipe == null) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop(); // FormScreen 닫기
        Navigator.of(context).pop(); // DetailScreen 닫기
      }
    }
  }

  void _addIngredient(String ingredientId, String displayName) {
    if (!_ingredientIds.contains(ingredientId)) {
      setState(() {
        _ingredientIds.add(ingredientId);
        _ingredientDisplayNames.add(displayName);
        _ingredientAmounts.add('');
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredientIds.removeAt(index);
      _ingredientDisplayNames.removeAt(index);
      _ingredientAmounts.removeAt(index);
    });
  }

  void _updateIngredientAmount(int index, String amount) {
    setState(() {
      if (index < _ingredientAmounts.length) {
        _ingredientAmounts[index] = amount;
      }
    });
  }

  void _addStep() {
    setState(() {
      _steps.add('');
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _updateStep(int index, String value) {
    setState(() {
      _steps[index] = value;
    });
  }

  void _moveStep(int oldIndex, int newIndex) {
    setState(() {
      final step = _steps.removeAt(oldIndex);
      _steps.insert(newIndex, step);
    });
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? '레시피 추가' : '레시피 수정'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: FilledButton(
            onPressed: _saveRecipe,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            child: Text(
              widget.recipe == null ? '레시피 저장' : '수정 완료',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            // ── 기본 정보 섹션 ──
            _SectionHeader(
              icon: Icons.info_outline,
              title: '기본 정보',
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '레시피 이름',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '레시피 이름을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '설명 (선택)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            // ── 조리 설정 섹션 ──
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              icon: Icons.settings,
              title: '조리 설정',
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 400) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _servingsController,
                          decoration: const InputDecoration(
                            labelText: '인분 (선택)',
                            border: OutlineInputBorder(),
                            suffixText: '인분',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _cookingTimeController,
                          decoration: const InputDecoration(
                            labelText: '조리시간 (선택)',
                            border: OutlineInputBorder(),
                            suffixText: '분',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      TextFormField(
                        controller: _servingsController,
                        decoration: const InputDecoration(
                          labelText: '인분 (선택)',
                          border: OutlineInputBorder(),
                          suffixText: '인분',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _cookingTimeController,
                        decoration: const InputDecoration(
                          labelText: '조리시간 (선택)',
                          border: OutlineInputBorder(),
                          suffixText: '분',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<DifficultyLevel>(
              value: _difficulty,
              decoration: const InputDecoration(
                labelText: '난이도',
                border: OutlineInputBorder(),
              ),
              items: DifficultyLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(_getDifficultyText(level)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _difficulty = value;
                  });
                }
              },
            ),

            // ── 분류 섹션 ──
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              icon: Icons.label_outline,
              title: '분류',
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
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
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: '태그 추가 (예: 매운맛, 건강식)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTag,
                ),
              ),
              onSubmitted: (_) => _addTag(),
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => setState(() => _tags.remove(tag)),
                  );
                }).toList(),
              ),
            ],

            // ── 재료 섹션 ──
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              icon: Icons.shopping_basket,
              title: '재료',
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            IngredientSearchField(
              onIngredientSelected: (normalizedName, displayName) {
                _addIngredient(normalizedName, displayName);
              },
            ),
            if (_ingredientIds.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Column(
                    children: List.generate(_ingredientIds.length, (index) {
                      return Column(
                        children: [
                          if (index > 0)
                            const Divider(height: 1, indent: 16, endIndent: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                IngredientChip(
                                  label: _ingredientDisplayNames[index],
                                  onDeleted: () => _removeIngredient(index),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: IngredientAmountField(
                                    initialValue:
                                        index < _ingredientAmounts.length
                                            ? _ingredientAmounts[index]
                                            : '',
                                    onChanged: (value) =>
                                        _updateIngredientAmount(index, value),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],

            // ── 조리 단계 섹션 ──
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              icon: Icons.format_list_numbered,
              title: '조리 단계',
              color: colorScheme.primary,
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addStep,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_steps.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Text('+ 버튼을 눌러 조리 단계를 추가하세요'),
                ),
              )
            else
              ...List.generate(_steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단: 번호 + 이동/삭제 버튼
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (index > 0)
                            IconButton(
                              icon: const Icon(Icons.arrow_upward, size: 20),
                              onPressed: () => _moveStep(index, index - 1),
                              visualDensity: VisualDensity.compact,
                              tooltip: '위로 이동',
                            ),
                          if (index < _steps.length - 1)
                            IconButton(
                              icon: const Icon(Icons.arrow_downward, size: 20),
                              onPressed: () => _moveStep(index, index + 1),
                              visualDensity: VisualDensity.compact,
                              tooltip: '아래로 이동',
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => _removeStep(index),
                            visualDensity: VisualDensity.compact,
                            tooltip: '삭제',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // 하단: 텍스트 필드 (전체 너비)
                      TextFormField(
                        initialValue: _steps[index],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '조리 단계를 입력하세요',
                        ),
                        maxLines: null,
                        minLines: 2,
                        onChanged: (value) => _updateStep(index, value),
                      ),
                    ],
                  ),
                );
              }),

            // 키보드 반응형 하단 패딩
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget? trailing;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
            ),
            if (trailing != null) ...[
              const Spacer(),
              trailing!,
            ],
          ],
        ),
        const Divider(height: AppSpacing.sm),
      ],
    );
  }
}
