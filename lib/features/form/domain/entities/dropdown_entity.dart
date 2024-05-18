import 'form_field_entity.dart';

class DropDownEntity extends MetaInfo {
  final List<String> options;

  DropDownEntity({
    required this.options,
    required super.label,
    required super.mandatory,
  });
}
