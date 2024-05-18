import 'form_field_entity.dart';

class CheckBoxEntity extends MetaInfo {
  final List<String> options;

  CheckBoxEntity({
    required this.options,
    required super.label,
    required super.mandatory,
  });
}
