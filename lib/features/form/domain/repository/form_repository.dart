import '../../../../core/resources/data_state.dart';

abstract class FormRepository {
  Future<DataState<Map<String, dynamic>>> getForm();
  Future<void> insertFormDataLocal(Map<String, dynamic> formData);
  Future<void> insertFormFieldsLocal(Map<String, dynamic> formData);
  List<Map<String, dynamic>> getFormFromLocal();
  Map<String, dynamic> getFormFieldsFromLocal();
  Future<DataState<void>> uploadFilesToAWS(String path, String folderName);
  Future<DataState<String>> submitFormData(List<Map<String, dynamic>> data);
  Future<void> clearLocalData();
}
