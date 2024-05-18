import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:polairs_assignment/core/constants/constants.dart';
// import 'package:polairs_assignment/core/constants/strings.dart';
import 'package:polairs_assignment/core/error/faliure.dart';
import 'package:polairs_assignment/core/util/toast_widget.dart';

import '../resources/data_state.dart';

class UploadFileToAwsImpl {
  Future<DataState<String>> uploadToAWS(File image, String folderPath) async {
    try {
      String imageKey = path.basename(image.path);
      StorageUploadFileOptions options = const StorageUploadFileOptions();
      Amplify.Storage.uploadFile(
          path: StoragePath.fromString('public/$folderPath/$imageKey'),
          localFile: AWSFile.fromPath(image.absolute.path),
          options: options);

      return DataSuccess(Urls.getAWSUrl(folderPath, imageKey));
    } catch (e) {
      ToastWidget.showToast(e.toString());
      return DataFailed(AWSUploadFaliure(e.toString()));
    }
  }
}
