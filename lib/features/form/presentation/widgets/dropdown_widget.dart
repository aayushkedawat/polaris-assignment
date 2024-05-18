import 'package:flutter/material.dart';
import 'package:polairs_assignment/features/form/domain/entities/dropdown_entity.dart';

import '../../../../core/constants/strings.dart';

class DropdownWidget extends StatefulWidget {
  final DropDownEntity dropDownEntity;
  final ValueChanged<String> onChanged;

  const DropdownWidget({
    super.key,
    required this.dropDownEntity,
    required this.onChanged,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String _dropdownValue = '';

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.dropDownEntity.options.first;
    widget.onChanged(_dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.dropDownEntity.label ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          validator: widget.dropDownEntity.mandatory?.toLowerCase() == 'yes'
              ? validateNonEmptyField
              : null,
          value: _dropdownValue,
          isExpanded: true, // Fill available space
          hint: const Text('Select'),
          items: widget.dropDownEntity.options
              .map((String option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _dropdownValue = value!;
              widget.onChanged(value); // Call the provided callback
            });
          },
        ),
      ],
    );
  }

  String? validateNonEmptyField(String? text) {
    if (text == null || text.isEmpty) {
      return Strings.validationError(widget.dropDownEntity.label ?? '');
    }
    return null;
  }
}
