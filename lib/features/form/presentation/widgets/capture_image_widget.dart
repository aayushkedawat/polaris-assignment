import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polairs_assignment/core/constants/constants.dart';
import 'package:polairs_assignment/core/constants/strings.dart';
import 'package:polairs_assignment/features/form/domain/entities/capture_images_entity.dart';
import 'package:path/path.dart' as path;

class CaptureImageWidget extends StatefulWidget {
  final CaptureImageEntity captureImageEntity;
  final ValueChanged onChanged;

  const CaptureImageWidget({
    super.key,
    required this.captureImageEntity,
    required this.onChanged,
  });

  @override
  State<CaptureImageWidget> createState() => _CaptureImageWidgetState();
}

class _CaptureImageWidgetState extends State<CaptureImageWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile?> images = [];
  List<String> imagePath = [];

  Future<void> _pickImage() async {
    List<XFile?> selectedImages = [];
    List<String> selectedImagesPath = [];
    List<String> selectedImagesAWSPath = [];
    int totalImagesToCapture = widget.captureImageEntity.noOfImagesToCapture;
    if (totalImagesToCapture > selectedImages.length) {
      XFile? selectedImagesFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 75,
      );
      String directory =
          (await getApplicationDocumentsDirectory()).absolute.path;
      String imageKey = path.basename(selectedImagesFile!.path);
      selectedImagesFile.saveTo('$directory/$imageKey');
      // UploadFileToAwsImpl().uploadToAWS(File(selectedImagesFile!.path));
      selectedImages.add(selectedImagesFile);
      selectedImagesPath.add('$directory/$imageKey');
      selectedImagesAWSPath.add(
          Urls.getAWSUrl(widget.captureImageEntity.savingFolder, imageKey));
    }
    if (selectedImages.isNotEmpty) {
      setState(() {
        images.addAll(selectedImages);
        imagePath.addAll(selectedImagesPath);
      });

      widget.onChanged({
        'local': selectedImagesPath,
        'aws': selectedImagesAWSPath,
      });
    }
  }

  String? validateImageCaptured() {
    if (widget.captureImageEntity.noOfImagesToCapture > images.length) {
      return Strings.validationError(widget.captureImageEntity.label ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        return validateImageCaptured();
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed:
                images.length < widget.captureImageEntity.noOfImagesToCapture
                    ? _pickImage
                    : null,
            child: Text(
                'Pick Images (Min: ${widget.captureImageEntity.noOfImagesToCapture})'),
          ),
          const SizedBox(height: 10),
          if (images.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final XFile? image = images[index];
                  return image != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(image.path),
                            height: 100,
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                        );
                },
              ),
            ),
          if (field.hasError)
            Text(
              field.errorText ??
                  Strings.validationError(
                      widget.captureImageEntity.label ?? ''),
              style: TextStyle(
                color: Colors.red.shade900,
              ),
            ),
        ],
      ),
    );
  }
}
