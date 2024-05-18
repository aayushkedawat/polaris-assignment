abstract class FormDataState {}

class FormDataInitial extends FormDataState {}

class FormDataAdded extends FormDataState {
  final Map<String, dynamic> data;
  FormDataAdded(this.data);
}
