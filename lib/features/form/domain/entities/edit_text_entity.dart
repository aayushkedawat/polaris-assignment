import 'form_field_entity.dart';

class EditTextEntity extends MetaInfo {
  final String componentInputType;

  EditTextEntity({
    required this.componentInputType,
    required super.label,
    required super.mandatory,
  });
}
