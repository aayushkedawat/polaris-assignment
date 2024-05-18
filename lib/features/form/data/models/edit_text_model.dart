// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../domain/entities/edit_text_entity.dart';
import 'meta_info_model.dart';

class EditTextModel extends MetaInfoModel {
  final String componentInputType;

  EditTextModel({
    required this.componentInputType,
    required super.label,
    required super.mandatory,
  });

  factory EditTextModel.fromJson(Map<String, dynamic> json) {
    return EditTextModel(
      componentInputType: json['component_input_type'],
      label: json['label'],
      mandatory: json['mandatory'],
    );
  }

  EditTextEntity toEntity() => EditTextEntity(
        componentInputType: componentInputType,
        label: label,
        mandatory: mandatory,
      );
}
