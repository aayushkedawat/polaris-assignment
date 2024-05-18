import '../../../../core/usecase/usecase.dart';
import '../repository/form_repository.dart';

class GetFormDataLocalUseCase
    implements UseCase<List<Map<String, dynamic>?>, String?> {
  final FormRepository _wikiRepository;

  GetFormDataLocalUseCase(this._wikiRepository);

  @override
  Future<List<Map<String, dynamic>>> execute({String? params}) async {
    return _wikiRepository.getFormFromLocal();
  }
}
