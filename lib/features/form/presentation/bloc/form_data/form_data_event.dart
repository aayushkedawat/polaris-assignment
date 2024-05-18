abstract class FormDataEvent {}

class AddFormDataEvent extends FormDataEvent {
  final String key;
  final dynamic value;
  AddFormDataEvent({required this.key, required this.value});
}
