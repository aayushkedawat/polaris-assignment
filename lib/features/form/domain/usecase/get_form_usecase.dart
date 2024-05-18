import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
// import '../entities/form_field_entity.dart';
import '../repository/form_repository.dart';

class GetFormUseCase
    implements UseCase<DataState<Map<String, dynamic>>, String?> {
  final FormRepository _wikiRepository;

  GetFormUseCase(this._wikiRepository);
  @override
  Future<DataState<Map<String, dynamic>>> execute({String? params}) {
    return _wikiRepository.getForm();
  }
}
