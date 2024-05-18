import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:polairs_assignment/features/form/data/data_source/local/form_local_sp.dart';
import 'package:polairs_assignment/features/form/data/data_source/remote/form_api_service.dart';
import 'package:polairs_assignment/features/form/domain/repository/form_repository.dart';
import 'package:polairs_assignment/features/form/domain/usecase/clear_local_data_usecase.dart';
import 'package:polairs_assignment/features/form/domain/usecase/get_form_usecase.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/form_data/form_data_bloc.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/remote/form_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/form/data/repository/form_repository_impl.dart';
import 'features/form/domain/usecase/add_form_data_local_usecase.dart';
import 'features/form/domain/usecase/add_form_fields_local_usecase.dart';
import 'features/form/domain/usecase/get_form_data_local_usecase.dart';
import 'features/form/domain/usecase/get_form_fields_local_usecase.dart';
import 'features/form/domain/usecase/submit_form_data_usecase.dart';
import 'features/form/domain/usecase/upload_file_aws_usecase.dart';

final sl = GetIt.instance;

Future<void> initialiseDependencies() async {
  // Http client
  sl.registerSingleton<http.Client>(http.Client());
  // Dependencies
  sl.registerSingleton<FormRemoteDataSource>(FormRemoteDataSourceImpl(sl()));

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton(sharedPreferences);
  sl.registerSingleton<FormDataLocalSharedPrefs>(
      FormDataLocalSharedPrefs(sl()));

  sl.registerSingleton<FormRepository>(FormRepositoryImpl(sl(), sl()));

  sl.registerSingleton<GetFormUseCase>(GetFormUseCase(sl()));
  sl.registerSingleton<SubmitFormUseCase>(SubmitFormUseCase(sl()));
  sl.registerSingleton<GetFormDataLocalUseCase>(GetFormDataLocalUseCase(sl()));
  sl.registerSingleton<AddFormDataLocalUseCase>(AddFormDataLocalUseCase(sl()));
  sl.registerSingleton<ClearLocalDataUseCase>(ClearLocalDataUseCase(sl()));
  sl.registerSingleton<AddFormFieldsLocalUseCase>(
      AddFormFieldsLocalUseCase(sl()));
  sl.registerSingleton<GetFormFieldsLocalUseCase>(
      GetFormFieldsLocalUseCase(sl()));

  sl.registerSingleton<UploadFileAwsUseCase>(UploadFileAwsUseCase(sl()));

  sl.registerFactory<RemoteFormBloc>(() => RemoteFormBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  sl.registerFactory<FormDataBloc>(() => FormDataBloc());
  // sl.registerFactory<LocalFormBloc>(() => LocalFormBloc(
  //       sl(),
  //       sl(),
  //       sl(),
  //       sl(),
  //       sl(),
  //     ));
}
