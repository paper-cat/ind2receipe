import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/models/ingredient.dart';
import 'package:idg2recipes/providers/ingredient_provider.dart';

class IngredientSearchField extends ConsumerStatefulWidget {
  final void Function(String normalizedName, String displayName)
      onIngredientSelected;

  const IngredientSearchField({
    super.key,
    required this.onIngredientSelected,
  });

  @override
  ConsumerState<IngredientSearchField> createState() =>
      _IngredientSearchFieldState();
}

class _IngredientSearchFieldState
    extends ConsumerState<IngredientSearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  List<Ingredient> _results = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _debounce?.cancel();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _query = '';
        _results = [];
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search(text);
    });
  }

  void _search(String query) {
    final asyncValue = ref.read(searchIngredientsProvider(query));
    final results = asyncValue.maybeWhen(
      data: (ingredients) => ingredients,
      orElse: () => <Ingredient>[],
    );
    if (mounted) {
      setState(() {
        _query = query;
        _results = results;
      });
    }
  }

  void _selectExisting(Ingredient ingredient) {
    widget.onIngredientSelected(
      ingredient.normalizedName,
      ingredient.displayName,
    );
    _clear();
  }

  Future<void> _selectNew(String query) async {
    final ingredientRepo =
        await ref.read(ingredientRepositoryProvider.future);
    final newIngredient =
        await ingredientRepo.getOrCreateIngredient(query);
    widget.onIngredientSelected(
      newIngredient.normalizedName,
      newIngredient.displayName,
    );
    _clear();
  }

  void _clear() {
    _controller.clear();
    _focusNode.unfocus();
  }

  Widget _buildSearchResults() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          ..._results.map((ingredient) {
            return ListTile(
              dense: true,
              title: Text(ingredient.displayName),
              subtitle: Text('${ingredient.usageCount}회 사용'),
              trailing: const Icon(Icons.add, size: 20),
              onTap: () => _selectExisting(ingredient),
            );
          }),
          _buildAddNewTile(_query),
        ],
      ),
    );
  }

  Widget _buildAddNewTile(String query) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.add_circle_outline),
      title: Text('새 재료: $query'),
      onTap: () => _selectNew(query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_query.isNotEmpty) ...[
          _buildSearchResults(),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: '재료 검색',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _clear,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
