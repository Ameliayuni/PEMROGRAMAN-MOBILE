// lib/widgets/custom_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;
  final Widget? suffixIcon;
  
  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.suffixIcon,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixText: prefixText,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}