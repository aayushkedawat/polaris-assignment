import 'strings.dart';

class Urls {
  static String getFormAPI() =>
      'https://chatbot-api.grampower.com/flutter-assignment';
  static String submitFormAPI() =>
      'https://chatbot-api.grampower.com/flutter-assignment/push';
  static String getAWSUrl(String folderPath, String imageKey) =>
      "https://${Strings.bucketId}.s3.${Strings.region}.amazonaws.com/public/$folderPath/$imageKey";
}
