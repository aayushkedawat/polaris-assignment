import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/form_repository.dart';

class SubmitFormUseCase implements UseCase<void, List<Map<String, dynamic>>?> {
  final FormRepository _wikiRepository;

  SubmitFormUseCase(this._wikiRepository);

  @override
  Future<DataState<String>> execute({List<Map<String, dynamic>>? params}) {
    return _wikiRepository.submitFormData(params!);
  }
}
