import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FormDataLocalSharedPrefs {
  SharedPreferences sharedPreferences;

  static const localFormDataKey = 'form_data';
  static const localFormFieldKey = 'form_fields';
  //  = SharedPreferences.getInstance();

  FormDataLocalSharedPrefs(this.sharedPreferences);

  Future<void> setLocalData(Map<String, dynamic> data) async {
    List<Map<String, dynamic>> existingData =
        List<Map<String, dynamic>>.from(getLocalData());

    existingData.add(data);
    sharedPreferences.setString(localFormDataKey, jsonEncode(existingData));
  }

  List<Map<String, dynamic>> getLocalData() {
    if (sharedPreferences.containsKey(localFormDataKey)) {
      String localDataString =
          sharedPreferences.getString(localFormDataKey) ?? '';
      if (localDataString != '') {
        return List<Map<String, dynamic>>.from(jsonDecode(localDataString));
      }
    }
    return List<Map<String, dynamic>>.from([]);
  }

  Map<String, dynamic>? getLocalFormFields() {
    String pref = sharedPreferences.getString(localFormFieldKey) ?? '';

    if (pref.isNotEmpty) {
      return jsonDecode(pref);
    }
    return null;
  }

  Future<void> setLocalFormFields(Map<String, dynamic> form) async {
    await sharedPreferences.setString(localFormFieldKey, jsonEncode(form));
  }

  Future<void> clearPrefs() async {
    await sharedPreferences.clear();
  }
}
