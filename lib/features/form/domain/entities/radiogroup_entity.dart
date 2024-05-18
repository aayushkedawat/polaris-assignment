import 'form_field_entity.dart';

class RadioGroupEntity extends MetaInfo {
  final List<String> options;

  RadioGroupEntity({
    required this.options,
    required super.label,
    required super.mandatory,
  });
}
