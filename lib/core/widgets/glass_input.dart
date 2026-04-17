import 'package:flutter/material.dart';

class GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;

  const GlassInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.textInputAction,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMinLines = obscureText ? 1 : minLines;
    final effectiveMaxLines = obscureText ? 1 : maxLines;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      minLines: effectiveMinLines,
      maxLines: effectiveMaxLines,
      textInputAction: textInputAction ?? TextInputAction.next,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        counterText: '',
      ),
    );
  }
}
