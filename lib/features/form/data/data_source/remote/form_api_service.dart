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

  // @override
  // Future<DataState<Map<String, List<MetaInfoModel>>>> getForm() async {
  //   try {
  //     final response = await client.get(Uri.parse(Urls.getFormAPI()));

  //     if (response.statusCode == 200) {
  //       List<MetaInfoModel> metaInfoModel = [];
  //       Map<String, dynamic> jsonResponse = jsonDecode(response.body);

  //       List fieldsJson = jsonResponse['fields'];

  //       for (var element in fieldsJson) {
  //         String componentType = element['component_type'];
  //         Map<String, dynamic> jsonMetaInfo = element['meta_info'];
  //         switch (componentType) {
  //           case 'EditText':
  //             metaInfoModel.add(EditTextModel.fromJson(jsonMetaInfo));
  //             break;
  //           case 'CheckBoxes':
  //             metaInfoModel.add(CheckBoxModel.fromJson(jsonMetaInfo));
  //             break;
  //           case 'DropDown':
  //             metaInfoModel.add(DropDownModel.fromJson(jsonMetaInfo));
  //             break;
  //           case 'RadioGroup':
  //             metaInfoModel.add(RadioGroupModel.fromJson(jsonMetaInfo));
  //             break;
  //           case 'CaptureImages':
  //             metaInfoModel.add(CaptureImageModel.fromJson(jsonMetaInfo));
  //             break;
  //         }
  //       }
  //       return DataSuccess({jsonResponse['form_name']: metaInfoModel});
  //     } else {
  //       return DataFailed(ServerFaliure(response.body));
  //     }
  //   } on http.ClientException catch (ex) {
  //     return DataFailed(ServerFaliure(ex.message));
  //   }
  // }

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
        return const DataSuccess('Success');
      } else {
        return DataFailed(ServerFaliure(response.body));
      }
    } on http.ClientException catch (ex) {
      return DataFailed(ServerFaliure(ex.message));
    }
  }
}
