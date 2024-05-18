import 'package:equatable/equatable.dart';

import '../../../../../core/error/faliure.dart';
import '../../../domain/entities/form_field_entity.dart';

abstract class RemoteFormState extends Equatable {
  final String? formName;
  final List<MetaInfo>? fields;
  final Faliure? error;

  const RemoteFormState({this.formName, this.error, this.fields});

  @override
  List<Object?> get props => [fields, error];
}

class FormInitial extends RemoteFormState {
  const FormInitial();
}

class FormLoading extends RemoteFormState {
  const FormLoading();
}

class FormLoaded extends RemoteFormState {
  const FormLoaded(List<MetaInfo> fields, String formName)
      : super(fields: fields, formName: formName);
}

class RemoteFormError extends RemoteFormState {
  const RemoteFormError(Faliure error) : super(error: error);
}

// class InitialLocalDataState extends LocalFormState {
//   const InitialLocalDataState();
// }

class LocalDataAdded extends RemoteFormState {
  const LocalDataAdded();
}

class LocalDataCleared extends RemoteFormState {
  const LocalDataCleared();
}

class LocalDataLoaded extends RemoteFormState {
  final List<Map<String, dynamic>?> data;
  const LocalDataLoaded(this.data);
}


// class RemoteFormSubmitted extends RemoteFormState {
//   const RemoteFormSubmitted();
// }
