import '../../../../core/usecase/usecase.dart';
import '../repository/form_repository.dart';

class AddFormDataLocalUseCase implements UseCase<void, Map<String, dynamic>?> {
  final FormRepository _wikiRepository;

  AddFormDataLocalUseCase(this._wikiRepository);

  @override
  Future<void> execute({Map<String, dynamic>? params}) {
    return _wikiRepository.insertFormDataLocal(params!);
  }
}
