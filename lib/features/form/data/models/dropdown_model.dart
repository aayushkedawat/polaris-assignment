// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../domain/entities/dropdown_entity.dart';
import 'meta_info_model.dart';

class DropDownModel extends MetaInfoModel {
  final List<String> options;

  DropDownModel({
    required this.options,
    required super.label,
    required super.mandatory,
  });

  factory DropDownModel.fromJson(Map<String, dynamic> json) {
    List<String> optionsModel = [];
    if (json['options'] != null) {
      optionsModel = [];
      json['options'].forEach((v) {
        optionsModel.add(v);
      });
    }
    return DropDownModel(
        options: optionsModel,
        label: json['label'],
        mandatory: json['mandatory']);
  }

  DropDownEntity toEntity() => DropDownEntity(
        label: label,
        mandatory: mandatory,
        options: options,
      );
}
