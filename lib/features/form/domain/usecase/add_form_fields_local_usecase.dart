import '../../../../core/usecase/usecase.dart';
import '../repository/form_repository.dart';

class AddFormFieldsLocalUseCase
    implements UseCase<void, Map<String, dynamic>?> {
  final FormRepository _wikiRepository;

  AddFormFieldsLocalUseCase(this._wikiRepository);

  @override
  Future<void> execute({Map<String, dynamic>? params}) {
    return _wikiRepository.insertFormFieldsLocal(params!);
  }
}
