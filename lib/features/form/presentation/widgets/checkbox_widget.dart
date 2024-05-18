import 'package:flutter/material.dart';
import 'package:polairs_assignment/features/form/domain/entities/checkbox_entity.dart';

class CheckboxWidget extends StatefulWidget {
  final CheckBoxEntity checkBoxEntity;

  const CheckboxWidget({
    super.key,
    required this.checkBoxEntity,
    required this.onChanged,
  });
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  final List<int> _selectedValues = [];

  @override
  void initState() {
    super.initState();
  }

  String? validateNonEmptyField(String? value) {
    if (_selectedValues.isEmpty) {
      return 'Please select ${widget.checkBoxEntity.label}';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: widget.checkBoxEntity.mandatory!.toLowerCase() == 'yes'
          ? validateNonEmptyField
          : null,
      autovalidateMode: widget.checkBoxEntity.mandatory!.toLowerCase() == 'yes'
          ? AutovalidateMode.onUserInteraction
          : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.checkBoxEntity.label ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Wrap(
            children:
                widget.checkBoxEntity.options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              return CheckboxListTile(
                title: Text(option),
                value: _selectedValues.contains(index),
                onChanged: (value) {
                  setState(() {
                    if (value ?? false) {
                      _selectedValues.add(index);
                    } else {
                      _selectedValues.remove(index);
                    }
                    List<Map<String, dynamic>> selectedValueList = [];
                    for (var element in _selectedValues) {
                      selectedValueList.add({
                        'option_name':
                            widget.checkBoxEntity.options.asMap()[element],
                        'option_index': element,
                      });
                    }
                    widget.onChanged(selectedValueList);
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, // Checkbox on the left
              );
            }).toList(),
          ),
          if (field.hasError)
            Text(
              field.errorText ?? 'Please select ${widget.checkBoxEntity.label}',
              style: TextStyle(
                color: Colors.red.shade900,
              ),
            ),
        ],
      ),
    );
  }
}
