import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController controller,
    required this.inputTextSize,
    required this.label,
    this.validator,
  }) : _nameController = controller;

  final TextEditingController _nameController;
  final double inputTextSize;
  final String label;
  final FormFieldValidator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      validator: validator,
      style: TextStyle(fontSize: inputTextSize),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        floatingLabelStyle: const TextStyle(
          color: ColorsManager.secondaryColor,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
    );
  }
}
