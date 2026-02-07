import 'package:flutter/material.dart';
import 'package:idg2recipes/models/ingredient.dart';

class IngredientFormDialog extends StatefulWidget {
  final Ingredient? initialIngredient;

  const IngredientFormDialog({
    super.key,
    this.initialIngredient,
  });

  @override
  State<IngredientFormDialog> createState() => _IngredientFormDialogState();
}

class _IngredientFormDialogState extends State<IngredientFormDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialIngredient?.displayName ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialIngredient != null;

    return AlertDialog(
      title: Text(isEditing ? '재료 수정' : '재료 추가'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '재료 이름',
            hintText: '예: 양파, 당근, 마늘',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '재료 이름을 입력해주세요';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final displayName = _nameController.text.trim();
              Navigator.pop(context, displayName);
            }
          },
          child: Text(isEditing ? '수정' : '추가'),
        ),
      ],
    );
  }
}
