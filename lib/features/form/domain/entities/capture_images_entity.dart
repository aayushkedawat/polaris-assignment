import 'form_field_entity.dart';

class CaptureImageEntity extends MetaInfo {
  final String componentInputType;
  final int noOfImagesToCapture;
  final String savingFolder;

  CaptureImageEntity({
    required this.componentInputType,
    required super.label,
    required this.savingFolder,
    required super.mandatory,
    required this.noOfImagesToCapture,
  });
}
