import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polairs_assignment/core/constants/strings.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/faliure.dart';
import '../../../../../core/resources/data_state.dart';

abstract class FormRemoteDataSource {
  Future<DataState<Map<String, dynamic>>> getForm();
  Future<DataState<String>> submitForm(List<Map<String, dynamic>> data);
}

class FormRemoteDataSourceImpl implements FormRemoteDataSource {
  final http.Client client;
  FormRemoteDataSourceImpl(this.client);
  @override
  Future<DataState<Map<String, dynamic>>> getForm() async {
    try {
      final response = await client.get(Uri.parse(Urls.getFormAPI()));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return DataSuccess(jsonResponse);
      } else {
        return DataFailed(ServerFaliure(response.body));
      }
    } on http.ClientException catch (ex) {
      return DataFailed(ServerFaliure(ex.message));
    }
  }

  @override
  Future<DataState<String>> submitForm(List<Map<String, dynamic>> data) async {
    try {
      for (var element in data) {
        element.remove(Strings.imagesLocalUpload);
      }
      final response = await client.post(
          Uri.parse(
            Urls.submitFormAPI(),
          ),
          body: {'data': jsonEncode(data)});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataSuccess(Strings.dataSubmitSuccessFully);
      } else {
        return DataFailed(ServerFaliure(response.body));
      }
    } on http.ClientException catch (ex) {
      return DataFailed(ServerFaliure(ex.message));
    }
  }
}
