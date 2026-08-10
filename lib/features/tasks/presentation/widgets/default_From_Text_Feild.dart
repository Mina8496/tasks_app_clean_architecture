import 'package:flutter/material.dart';

class DefaultFromTextFeild extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final Widget? label;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final GestureTapCallback? onTap;
  final bool? clickable;

  const DefaultFromTextFeild({
    super.key,
    required this.labelText,
    this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.label,
    this.prefix,
    this.onTap,
    this.clickable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enabled: clickable,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        label: label,
        prefix: prefix,
        border: OutlineInputBorder(),
      ),
    );
  }
}
