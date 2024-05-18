import '../../../../core/usecase/usecase.dart';
import '../repository/form_repository.dart';

class GetFormFieldsLocalUseCase
    implements UseCase<Map<String, dynamic>, String?> {
  final FormRepository _formRepository;

  GetFormFieldsLocalUseCase(this._formRepository);

  @override
  Future<Map<String, dynamic>> execute({String? params}) async {
    return _formRepository.getFormFieldsFromLocal();
  }
}
