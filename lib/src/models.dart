enum HttpPackage { dio, http, getConnect }

class GenOptions {
  final bool isRequired;
  final bool useCopyWith;
  final bool useFromJson;
  final bool useToJson;
  final HttpPackage httpPackage;

  GenOptions({
    required this.isRequired,
    required this.useCopyWith,
    required this.useFromJson,
    required this.useToJson,
    required this.httpPackage,
  });
}

class ModelField {
  final String name;
  final String type;
  final Map<String, ModelField>? subFields;
  final bool isList;
  ModelField({
    required this.name,
    required this.type,
    this.subFields,
    this.isList = false,
  });
}
