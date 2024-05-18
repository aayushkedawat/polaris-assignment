class FormFieldEntity {
  String? formName;
  List<Fields>? fields;

  FormFieldEntity({
    this.formName,
    this.fields,
  });
}

class Fields {
  MetaInfo? metaInfo;
  String? componentType;

  Fields({
    this.metaInfo,
    this.componentType,
  });
}

abstract class MetaInfo {
  String? label;
  String? mandatory;

  MetaInfo({
    this.label,
    this.mandatory,
  });
}
