import 'package:polairs_assignment/features/form/domain/entities/form_field_entity.dart';

abstract class MetaInfoModel extends MetaInfo {
  MetaInfoModel({
    required super.label,
    required super.mandatory,
  });
}
