// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../domain/entities/checkbox_entity.dart';
import 'meta_info_model.dart';

class CheckBoxModel extends MetaInfoModel {
  final List<String> options;

  CheckBoxModel({
    required this.options,
    required super.label,
    required super.mandatory,
  });

  CheckBoxEntity toEntity() => CheckBoxEntity(
        label: label,
        mandatory: mandatory,
        options: options,
      );
  factory CheckBoxModel.fromJson(Map<String, dynamic> json) {
    List<String> optionsModel = [];
    if (json['options'] != null) {
      optionsModel = [];
      json['options'].forEach((v) {
        optionsModel.add(v);
      });
    }
    return CheckBoxModel(
        options: optionsModel,
        label: json['label'],
        mandatory: json['mandatory']);
  }
}
