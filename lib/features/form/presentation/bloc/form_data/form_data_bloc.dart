import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/form_data/form_data_event.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/form_data/form_data_state.dart';

class FormDataBloc extends Bloc<FormDataEvent, FormDataState> {
  Map<String, dynamic> formdata = {};
  FormDataBloc() : super(FormDataInitial()) {
    on<AddFormDataEvent>((event, emit) {
      formdata[event.key] = event.value;
      emit(FormDataAdded(formdata));
    });
  }
}
