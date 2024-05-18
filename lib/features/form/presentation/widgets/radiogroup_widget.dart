import 'package:flutter/material.dart';
import '../../domain/entities/radiogroup_entity.dart';

class RadioGroupWidget extends StatefulWidget {
  final RadioGroupEntity radioGroupEntity;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const RadioGroupWidget(
      {super.key, required this.radioGroupEntity, required this.onChanged});

  @override
  State<RadioGroupWidget> createState() => _RadioGroupWidgetState();
}

class _RadioGroupWidgetState extends State<RadioGroupWidget> {
  int _selectedValue = -1; // To track the selected radio button index

  String? validateNonEmptyField(String? value) {
    if (_selectedValue == -1) {
      return 'Please select ${widget.radioGroupEntity.label}';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: widget.radioGroupEntity.mandatory!.toLowerCase() == 'yes'
          ? validateNonEmptyField
          : null,
      autovalidateMode:
          widget.radioGroupEntity.mandatory!.toLowerCase() == 'yes'
              ? AutovalidateMode.onUserInteraction
              : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.radioGroupEntity.label ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Wrap(
            children:
                widget.radioGroupEntity.options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              return RadioListTile.adaptive(
                title: Text(option),
                value: index,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value as int;
                  });
                  widget.onChanged(
                      {'option_name': option, 'option_index': value ?? 0});
                },
              );
            }).toList(),
          ),
          if (field.hasError)
            Text(
              field.errorText ??
                  'Please select ${widget.radioGroupEntity.label}',
              style: TextStyle(
                color: Colors.red.shade900,
              ),
            )
        ],
      ),
    );
  }
}
