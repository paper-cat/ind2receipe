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
      // 레시피 리스트(HomeScreen)로 이동
      // 새 레시피 추가: HomeScreen -> FormScreen (1번 pop)
      // 레시피 수정: HomeScreen -> DetailScreen -> FormScreen (2번 pop)
      if (widget.recipe == null) {
        // 새 레시피 추가
        Navigator.of(context).pop();
      } else {
        // 레시피 수정 - DetailScreen과 FormScreen 모두 닫기
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? '레시피 추가' : '레시피 수정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '설명 (선택)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 400) {
                  // 넓은 화면: Row
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
                      const SizedBox(width: 16),
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
                  // 좁은 화면: Column
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
                      const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 24),
            Text(
              '카테고리',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
            Text(
              '태그',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 24),
            Text(
              '재료',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            IngredientSearchField(
              onIngredientSelected: (normalizedName, displayName) {
                _addIngredient(normalizedName, displayName);
              },
            ),
            if (_ingredientIds.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...List.generate(_ingredientIds.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      IngredientChip(
                        label: _ingredientDisplayNames[index],
                        onDeleted: () => _removeIngredient(index),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: IngredientAmountField(
                          initialValue: index < _ingredientAmounts.length
                              ? _ingredientAmounts[index]
                              : '',
                          onChanged: (value) =>
                              _updateIngredientAmount(index, value),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '조리 단계',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addStep,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_steps.isEmpty)
              const Center(
                child: Text('+ 버튼을 눌러 조리 단계를 추가하세요'),
              )
            else
              ...List.generate(_steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: _steps[index],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '조리 단계를 입력하세요',
                          ),
                          maxLines: 3,
                          onChanged: (value) => _updateStep(index, value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeStep(index),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
