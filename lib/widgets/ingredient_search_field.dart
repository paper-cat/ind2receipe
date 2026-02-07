import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/models/ingredient.dart';
import 'package:idg2recipes/providers/ingredient_provider.dart';

class IngredientSearchField extends ConsumerStatefulWidget {
  final void Function(String normalizedName, String displayName) onIngredientSelected;

  const IngredientSearchField({
    super.key,
    required this.onIngredientSelected,
  });

  @override
  ConsumerState<IngredientSearchField> createState() => _IngredientSearchFieldState();
}

class _IngredientSearchFieldState extends ConsumerState<IngredientSearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<Ingredient>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final query = textEditingValue.text.trim();
        if (query.isEmpty) {
          return const Iterable<Ingredient>.empty();
        }

        // Riverpod Provider 호출 (AsyncValue → Iterable)
        final asyncValue = ref.read(searchIngredientsProvider(query));
        return asyncValue.maybeWhen(
          data: (ingredients) => ingredients,
          orElse: () => const Iterable<Ingredient>.empty(),
        );
      },
      displayStringForOption: (Ingredient ingredient) => ingredient.displayName,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: '재료 검색',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final query = _controller.text.trim();
        final optionsList = options.toList();

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  // 검색 결과 리스트
                  ...optionsList.map((ingredient) {
                    return ListTile(
                      dense: true,
                      title: Text(ingredient.displayName),
                      subtitle: Text('${ingredient.usageCount}회 사용'),
                      trailing: const Icon(Icons.add, size: 20),
                      onTap: () {
                        widget.onIngredientSelected(
                          ingredient.normalizedName,
                          ingredient.displayName,
                        );
                        _controller.clear();
                        _focusNode.unfocus();
                      },
                    );
                  }),
                  // "새 재료 추가" 옵션
                  if (query.isNotEmpty && optionsList.isEmpty)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.add_circle_outline),
                      title: Text('새 재료: $query'),
                      onTap: () async {
                        final ingredientRepo = await ref.read(
                          ingredientRepositoryProvider.future,
                        );
                        final newIngredient = await ingredientRepo
                            .getOrCreateIngredient(query);
                        widget.onIngredientSelected(
                          newIngredient.normalizedName,
                          newIngredient.displayName,
                        );
                        _controller.clear();
                        _focusNode.unfocus();
                      },
                    ),
                  // 검색 결과가 있어도 새 재료 추가 옵션 표시
                  if (query.isNotEmpty && optionsList.isNotEmpty)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.add_circle_outline),
                      title: Text('새 재료: $query'),
                      onTap: () async {
                        final ingredientRepo = await ref.read(
                          ingredientRepositoryProvider.future,
                        );
                        final newIngredient = await ingredientRepo
                            .getOrCreateIngredient(query);
                        widget.onIngredientSelected(
                          newIngredient.normalizedName,
                          newIngredient.displayName,
                        );
                        _controller.clear();
                        _focusNode.unfocus();
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
      onSelected: (Ingredient ingredient) {
        widget.onIngredientSelected(
          ingredient.normalizedName,
          ingredient.displayName,
        );
        _controller.clear();
      },
    );
  }
}
