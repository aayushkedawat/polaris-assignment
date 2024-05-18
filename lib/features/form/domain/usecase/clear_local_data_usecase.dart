import '../../../../core/usecase/usecase.dart';
import '../repository/form_repository.dart';

class ClearLocalDataUseCase implements UseCase<void, void> {
  final FormRepository _wikiRepository;

  ClearLocalDataUseCase(this._wikiRepository);

  @override
  Future<void> execute({void params}) async {
    return _wikiRepository.clearLocalData();
  }
}
