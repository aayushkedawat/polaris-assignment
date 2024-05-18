// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../domain/entities/radiogroup_entity.dart';
import 'meta_info_model.dart';

class RadioGroupModel extends MetaInfoModel {
  final List<String> options;

  RadioGroupModel({
    required this.options,
    required super.label,
    required super.mandatory,
  });

  factory RadioGroupModel.fromJson(Map<String, dynamic> json) {
    List<String> optionsModel = [];
    if (json['options'] != null) {
      optionsModel = [];
      json['options'].forEach((v) {
        optionsModel.add(v);
      });
    }
    return RadioGroupModel(
      options: optionsModel,
      label: json['label'],
      mandatory: json['mandatory'],
    );
  }

  RadioGroupEntity toEntity() => RadioGroupEntity(
        label: label,
        mandatory: mandatory,
        options: options,
      );
}
