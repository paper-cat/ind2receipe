import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;

  const IngredientChip({
    super.key,
    required this.label,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 20) : null,
      onDeleted: onDeleted,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
