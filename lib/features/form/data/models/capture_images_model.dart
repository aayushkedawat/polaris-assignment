// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../domain/entities/capture_images_entity.dart';
import 'meta_info_model.dart';

class CaptureImageModel extends MetaInfoModel {
  final String componentInputType;
  final int noOfImagesToCapture;
  final String savingFolder;

  CaptureImageModel({
    required this.componentInputType,
    required super.label,
    required this.savingFolder,
    required super.mandatory,
    required this.noOfImagesToCapture,
  });
  factory CaptureImageModel.fromJson(Map<String, dynamic> json) {
    return CaptureImageModel(
      componentInputType: json['component_input_type'],
      label: json['label'],
      savingFolder: json['saving_folder'],
      mandatory: json['mandatory'],
      noOfImagesToCapture: json['no_of_images_to_capture'],
    );
  }

  CaptureImageEntity toEntity() => CaptureImageEntity(
        label: label,
        mandatory: mandatory,
        componentInputType: componentInputType,
        noOfImagesToCapture: noOfImagesToCapture,
        savingFolder: savingFolder,
      );
}
