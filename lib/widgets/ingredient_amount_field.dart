import 'package:flutter/material.dart';

class IngredientAmountField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const IngredientAmountField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<IngredientAmountField> createState() => _IngredientAmountFieldState();
}

class _IngredientAmountFieldState extends State<IngredientAmountField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // 키보드 올라올 때 자동 스크롤
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.5, // 화면 중앙에 위치
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        labelText: '양 (예: 200g, 2개)',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: widget.onChanged,
    );
  }
}
