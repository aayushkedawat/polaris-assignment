import 'dart:io';

import 'package:polairs_assignment/core/util/upload_file_to_aws.dart';
import 'package:polairs_assignment/features/form/data/data_source/local/form_local_sp.dart';
import 'package:polairs_assignment/features/form/data/data_source/remote/form_api_service.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/entities/form_field_entity.dart';
import '../../domain/repository/form_repository.dart';

class FormRepositoryImpl implements FormRepository {
  final FormRemoteDataSource _formRemoteDataSource;

  final FormDataLocalSharedPrefs _formDataLocalSharedPrefs;

  FormRepositoryImpl(
      this._formRemoteDataSource, this._formDataLocalSharedPrefs);

  @override
  Future<void> insertFormDataLocal(Map<String, dynamic> formData) {
    return _formDataLocalSharedPrefs.setLocalData(formData);
  }

  @override
  Future<DataState<Map<String, dynamic>>> getForm() {
    return _formRemoteDataSource.getForm();
  }

  @override
  Future<DataState<String>> submitFormData(List<Map<String, dynamic>> data) {
    return _formRemoteDataSource.submitForm(data);
  }

  @override
  List<Map<String, dynamic>> getFormFromLocal() {
    return _formDataLocalSharedPrefs.getLocalData();
  }

  @override
  Future<DataState<String>> uploadFilesToAWS(
      String path, String folderName) async {
    return UploadFileToAwsImpl().uploadToAWS(File(path), folderName);
  }

  @override
  Future<void> clearLocalData() async {
    await _formDataLocalSharedPrefs.clearPrefs();
  }

  @override
  Map<String, dynamic> getFormFieldsFromLocal() {
    return _formDataLocalSharedPrefs.getLocalFormFields()!;
  }

  @override
  Future<void> insertFormFieldsLocal(Map<String, dynamic> formData) {
    return _formDataLocalSharedPrefs.setLocalFormFields(formData);
  }
}
