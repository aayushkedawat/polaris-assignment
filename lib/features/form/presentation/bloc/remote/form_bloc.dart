import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polairs_assignment/core/util/connectivity_check.dart';
import 'package:polairs_assignment/features/form/domain/usecase/get_form_fields_local_usecase.dart';
import 'package:polairs_assignment/features/form/domain/usecase/get_form_usecase.dart';
import 'package:polairs_assignment/features/form/domain/usecase/submit_form_data_usecase.dart';
import 'package:polairs_assignment/features/form/domain/usecase/upload_file_aws_usecase.dart';
import '../../../../../background_sync.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/error/faliure.dart';
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
import 'form_event.dart';
import 'form_state.dart';

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
          List<MetaInfoModel> fieldList = parseJsonToModel(dataState.data!);

          emit(FormLoaded(fieldList, dataState.data!['form_name']));
        } else if (dataState is DataFailed) {
          emit(RemoteFormError(dataState.exception!));
        }
      } else {
        var fieldListJson = await _getFormFieldsLocalUseCase.execute();
        if (fieldListJson.isEmpty) {
          emit(RemoteFormError(NoDataFaliure(Strings.dataNotAvailable)));
          return;
        }
        List<MetaInfoModel> fieldList = parseJsonToModel(fieldListJson);

        emit(FormLoaded(fieldList, fieldListJson['form_name']));
      }
    });

    on<SubmitRemoteData>((event, emit) async {
      emit(const FormLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      var formDataList = event.formDataMap;
      print('---->> $formDataList');

      if (await ConnectivityCheck.isConnected()) {
        if (formDataList.first.containsKey(Strings.imagesLocalUpload)) {
          Map<String, dynamic> imageFolderFiles =
              formDataList.first[Strings.imagesLocalUpload];

          imageFolderFiles.forEach((folderName, value) {
            (List<String>.from(value)).forEach((imagePath) async {
              await _awsUseCase.execute(params: [imagePath, folderName]);
            });
          });
        }
        final dataState =
            await _submitFormUseCase.execute(params: formDataList);
        if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
          Fluttertoast.showToast(msg: Strings.dataSubmitSuccessFully);
        } else if (dataState is DataFailed) {
          emit(RemoteFormError(dataState.exception!));
        }
      } else {
        print(event.formDataMap.first);
        await _addFormDataLocalUseCase.execute(params: event.formDataMap.first);
        var formFieldMapLocal = await _getFormFieldsLocalUseCase.execute();
        if (formFieldMapLocal.isEmpty) {
          emit(RemoteFormError(NoDataFaliure(Strings.dataNotAvailable)));
          return;
        }
        List<MetaInfoModel> fieldList = parseJsonToModel(formFieldMapLocal);

        emit(FormLoaded(fieldList, formFieldMapLocal['form_name']));
        Fluttertoast.showToast(msg: Strings.dataSubmitSuccessFully);
      }
    });

    // on<AddLocalData>((event, emit) async {
    //   await _addFormDataLocalUseCase.execute(params: event.data);
    //   // emit(const LocalDataAdded());
    // });
    on<GetLocalData>((event, emit) async {
      List<Map<String, dynamic>> formFieldMapLocal =
          await _getFormDataLocalUseCase.execute();
      emit(LocalDataLoaded(formFieldMapLocal));
    });
    on<SyncData>((event, emit) async {
      List<Map<String, dynamic>> formDataMapLocal =
          await _getFormDataLocalUseCase.execute();
      if (formDataMapLocal.isNotEmpty) {
        for (var element in formDataMapLocal) {
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

          await NotificationService().showNotification(
              1, 'success', 'Background Sync Complete', false);
        }
        await _submitFormUseCase.execute(params: formDataMapLocal);
        emit(LocalDataLoaded(formDataMapLocal));
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
