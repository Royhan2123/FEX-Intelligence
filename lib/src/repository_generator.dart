import 'utils.dart';

void generateRepo(String name) {
  final className = '${toPascalCase(name)}Repository';
  final serviceName = '${toPascalCase(name)}Service';
  final modelName = '${toPascalCase(name)}Model';
  final buffer = StringBuffer();

  buffer.writeln("import '../models/${name.toLowerCase()}_model.dart';");
  buffer.writeln("import '../services/${name.toLowerCase()}_service.dart';");
  buffer.writeln("import '../network/network_result.dart';");

  buffer.writeln('\nclass $className {');
  buffer.writeln('  final $serviceName _service;');
  buffer.writeln('  $className(this._service);');

  buffer.writeln('\n  Future<NetworkResult<List<$modelName>>> getAll() => _service.fetch${toPascalCase(name)}s();');
  buffer.writeln('\n  Future<NetworkResult<$modelName>> getById(String id) => _service.fetch${toPascalCase(name)}ById(id);');
  buffer.writeln('\n  Future<NetworkResult<void>> create($modelName data) => _service.create${toPascalCase(name)}(data);');
  buffer.writeln('\n  Future<NetworkResult<void>> update(String id, $modelName data) => _service.update${toPascalCase(name)}(id, data);');
  buffer.writeln('\n  Future<NetworkResult<void>> delete(String id) => _service.delete${toPascalCase(name)}(id);');

  buffer.writeln('}');
  
  saveFile('lib/data/repositories', '${name.toLowerCase()}_repository.dart', buffer.toString());
}
