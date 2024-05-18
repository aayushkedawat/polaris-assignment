import 'package:flutter/material.dart';
import 'package:polairs_assignment/features/form/domain/entities/edit_text_entity.dart';

class EditTextWidget extends StatelessWidget {
  final EditTextEntity editTextEntity;
  final ValueChanged onChanged;
  const EditTextWidget({
    super.key,
    required this.editTextEntity,
    required this.onChanged,
  });
  String? validateNonEmptyField(String? text) {
    if (text == null || text.isEmpty) {
      return 'Please enter ${editTextEntity.label}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(editTextEntity.label ?? ''),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: editTextEntity.mandatory?.toLowerCase() == 'yes'
          ? validateNonEmptyField
          : null,
      keyboardType: getTextInput(),
      onChanged: onChanged,
    );
  }

  TextInputType getTextInput() {
    TextInputType textInputType = TextInputType.text;

    switch (editTextEntity.componentInputType) {
      case 'TEXT':
        textInputType = TextInputType.text;
        break;
      case 'INTEGER':
        textInputType = TextInputType.number;
        break;
      default:
        textInputType = TextInputType.text;
        break;
    }
    return textInputType;
  }
}
