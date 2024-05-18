import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polairs_assignment/core/util/connectivity_check.dart';
import 'package:polairs_assignment/features/form/domain/usecase/get_form_fields_local_usecase.dart';
import 'package:polairs_assignment/features/form/domain/usecase/get_form_usecase.dart';
import 'package:polairs_assignment/features/form/domain/usecase/submit_form_data_usecase.dart';
import 'package:polairs_assignment/features/form/domain/usecase/upload_file_aws_usecase.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../data/models/capture_images_model.dart';
import '../../../data/models/checkbox_model.dart';
import '../../../data/models/dropdown_model.dart';
import '../../../data/models/edit_text_model.dart';
import '../../../data/models/meta_info_model.dart';
import '../../../data/models/radiogroup_model.dart';
import '../../../domain/usecase/add_form_data_local_usecase.dart';
import '../../../domain/usecase/add_form_fields_local_usecase.dart';
import '../../../domain/usecase/clear_local_data_usecase.dart';
import '../../../domain/usecase/get_form_data_local_usecase.dart';
import 'remote_form_event.dart';
import 'remote_form_state.dart';

class RemoteFormBloc extends Bloc<RemoteFormEvent, RemoteFormState> {
  final GetFormUseCase _getFormUseCase;
  final UploadFileAwsUseCase _awsUseCase;
  final AddFormFieldsLocalUseCase _addFormFieldsUseCase;
  final GetFormFieldsLocalUseCase _getFormFieldsLocalUseCase;

  final GetFormDataLocalUseCase _getFormDataLocalUseCase;

  final AddFormDataLocalUseCase _addFormDataLocalUseCase;

  final ClearLocalDataUseCase _clearLocalDataUseCase;

  final SubmitFormUseCase _submitFormUseCase;
  RemoteFormBloc(
    this._getFormUseCase,
    this._submitFormUseCase,
    this._getFormFieldsLocalUseCase,
    this._awsUseCase,
    this._addFormFieldsUseCase,
    this._addFormDataLocalUseCase,
    this._clearLocalDataUseCase,
    this._getFormDataLocalUseCase,
  ) : super(const FormInitial()) {
    on<GetRemoteData>((event, emit) async {
      emit(const FormLoading());
      if (await ConnectivityCheck.isConnected()) {
        final dataState = await _getFormUseCase.execute();

        if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
          await _addFormFieldsUseCase.execute(params: dataState.data);
          List<MetaInfoModel> list = parseJsonToModel(dataState.data!);

          emit(FormLoaded(list, dataState.data!['form_name']));
        } else if (dataState is DataFailed) {
          emit(RemoteFormError(dataState.exception!));
        }
      } else {
        var data = await _getFormFieldsLocalUseCase.execute();
        List<MetaInfoModel> list = parseJsonToModel(data);

        emit(FormLoaded(list, data['form_name']));
      }
    });

    on<SubmitRemoteData>((event, emit) async {
      // emit(const RemoteFormLoading());
      var element = event.formDataMap;

      if (await ConnectivityCheck.isConnected()) {
        if (element.first.containsKey(Strings.imagesLocalUpload)) {
          Map<String, dynamic> imageFolderFiles =
              element.first[Strings.imagesLocalUpload];

          imageFolderFiles.forEach((key, value) {
            (List<String>.from(value)).forEach((url) async {
              await _awsUseCase.execute(params: [url, key]);
            });
          });
        }
        final dataState = await _submitFormUseCase.execute(params: element);
        if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
          Fluttertoast.showToast(msg: 'Data submitted successfully');
        } else if (dataState is DataFailed) {
          emit(RemoteFormError(dataState.exception!));
        }
      } else {
        Fluttertoast.showToast(msg: 'Data submitted successfully');
        await _addFormDataLocalUseCase.execute(params: event.formDataMap.first);
      }
    });

    // on<AddLocalData>((event, emit) async {
    //   await _addFormDataLocalUseCase.execute(params: event.data);
    //   // emit(const LocalDataAdded());
    // });
    on<GetLocalData>((event, emit) async {
      List<Map<String, dynamic>> data =
          await _getFormDataLocalUseCase.execute();
      emit(LocalDataLoaded(data));
    });
    on<SyncData>((event, emit) async {
      List<Map<String, dynamic>> data =
          await _getFormDataLocalUseCase.execute();
      if (data.isNotEmpty) {
        for (var element in data) {
          if (element.containsKey(Strings.imagesLocalUpload)) {
            Map<String, dynamic> imageFolderFiles =
                element[Strings.imagesLocalUpload];

            imageFolderFiles.forEach((key, value) {
              (List<String>.from(value)).forEach((url) async {
                await _awsUseCase.execute(params: [url, key]);
              });
            });
          }
          await _clearLocalDataUseCase.execute();
          Fluttertoast.showToast(msg: 'Successfully synced data');
        }
        await _submitFormUseCase.execute(params: data);
        emit(LocalDataLoaded(data));
      }
    });
  }

  List<MetaInfoModel> parseJsonToModel(Map<String, dynamic> json) {
    List<MetaInfoModel> metaInfoModel = [];
    Map<String, dynamic> jsonResponse = json;
    // jsonDecode(json);

    List fieldsJson = jsonResponse['fields'];

    for (var element in fieldsJson) {
      String componentType = element['component_type'];
      Map<String, dynamic> jsonMetaInfo = element['meta_info'];
      switch (componentType) {
        case 'EditText':
          metaInfoModel.add(EditTextModel.fromJson(jsonMetaInfo));
          break;
        case 'CheckBoxes':
          metaInfoModel.add(CheckBoxModel.fromJson(jsonMetaInfo));
          break;
        case 'DropDown':
          metaInfoModel.add(DropDownModel.fromJson(jsonMetaInfo));
          break;
        case 'RadioGroup':
          metaInfoModel.add(RadioGroupModel.fromJson(jsonMetaInfo));
          break;
        case 'CaptureImages':
          metaInfoModel.add(CaptureImageModel.fromJson(jsonMetaInfo));
          break;
      }
    }
    return metaInfoModel;
  }
}
