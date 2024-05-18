import '../../../../core/resources/data_state.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/form_repository.dart';

class UploadFileAwsUseCase implements UseCase<DataState<void>, List<String>> {
  final FormRepository _formRepository;

  UploadFileAwsUseCase(this._formRepository);

  @override
  Future<DataState<void>> execute({List<String>? params}) {
    return _formRepository.uploadFilesToAWS(params![0], params[1]);
  }
}
