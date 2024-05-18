// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:polairs_assignment/core/constants/strings.dart';
// import 'package:polairs_assignment/features/form/domain/usecase/add_form_data_local_usecase.dart';
// import 'package:polairs_assignment/features/form/domain/usecase/clear_local_data_usecase.dart';
// import 'package:polairs_assignment/features/form/domain/usecase/get_form_data_local_usecase.dart';
// import 'package:polairs_assignment/features/form/domain/usecase/submit_form_data_usecase.dart';
// import 'package:polairs_assignment/features/form/domain/usecase/upload_file_aws_usecase.dart';
// import 'package:polairs_assignment/features/form/presentation/bloc/local/local_form_event.dart';
// import 'package:polairs_assignment/features/form/presentation/bloc/local/local_form_state.dart';

// class LocalFormBloc extends Bloc<LocalFormEvent, LocalFormState> {
//   final GetFormDataLocalUseCase _getFormDataLocalUseCase;

//   final AddFormDataLocalUseCase _addFormDataLocalUseCase;

//   final SubmitFormUseCase _submitFormUseCase;

//   final UploadFileAwsUseCase _awsUseCase;
//   final ClearLocalDataUseCase _clearLocalDataUseCase;

//   LocalFormBloc(this._addFormDataLocalUseCase, this._getFormDataLocalUseCase,
//       this._submitFormUseCase, this._awsUseCase, this._clearLocalDataUseCase)
//       : super(const InitialLocalDataState()) {
//     on<AddLocalData>((event, emit) async {
//       await _addFormDataLocalUseCase.execute(params: event.data);
//       emit(const LocalDataAdded());
//     });
//     on<GetLocalData>((event, emit) async {
//       List<Map<String, dynamic>> data =
//           await _getFormDataLocalUseCase.execute();
//       emit(LocalDataLoaded(data));
//     });
//     on<SyncData>((event, emit) async {
//       List<Map<String, dynamic>> data =
//           await _getFormDataLocalUseCase.execute();
//       if (data.isNotEmpty) {
//         for (var element in data) {
//           if (element.containsKey(Strings.imagesLocalUpload)) {
//             Map<String, dynamic> imageFolderFiles =
//                 element[Strings.imagesLocalUpload];

//             imageFolderFiles.forEach((key, value) {
//               (List<String>.from(value)).forEach((url) async {
//                 await _awsUseCase.execute(params: [url, key]);
//               });
//             });
//           }
//           await _clearLocalDataUseCase.execute();
//           Fluttertoast.showToast(msg: 'Successfully synced data');
//         }
//         await _submitFormUseCase.execute(params: data);
//         emit(LocalDataLoaded(data));
//       }
//     });
//   }
// }
