import 'dart:async';

import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/constants/strings.dart';
import 'core/resources/data_state.dart';
import 'features/form/data/data_source/local/form_local_sp.dart';
import 'features/form/domain/usecase/clear_local_data_usecase.dart';
import 'features/form/domain/usecase/submit_form_data_usecase.dart';
import 'features/form/domain/usecase/upload_file_aws_usecase.dart';
import 'injection_container.dart';

class SyncBloc {
  void scheduleBackgroundSync() {
    Workmanager().registerPeriodicTask(
      'syncTask',
      'syncDataTask',
      frequency: const Duration(hours: 1),
    );
  }

  Future<bool> syncData() async {
    FormDataLocalSharedPrefs formDataLocalSharedPrefs =
        FormDataLocalSharedPrefs(sl());
    List<Map<String, dynamic>> formDataList =
        formDataLocalSharedPrefs.getLocalData();
    if (formDataList.isNotEmpty) {
      for (var element in formDataList) {
        if (element.containsKey(Strings.imagesLocalUpload)) {
          Map<String, dynamic> imageFolderFiles =
              element[Strings.imagesLocalUpload];

          imageFolderFiles.forEach((key, value) {
            (List<String>.from(value)).forEach((url) async {
              await UploadFileAwsUseCase(sl()).execute(params: [url, key]);
            });
          });
        }
        final dataState =
            await SubmitFormUseCase(sl()).execute(params: formDataList);
        if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
          NotificationService().showNotification(
              2, 'Success', dataState.data ?? 'Background sync success', false);
        } else if (dataState is DataFailed) {
          NotificationService()
              .showNotification(2, 'Failed', 'Background sync failed', false);
        }
        await ClearLocalDataUseCase(sl()).execute();
      }
      return true;
    } else {
      return false;
    }
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('sync');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    bool ongoing,
  ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'bgsync',
      'bgsync',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      ongoing: ongoing,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
