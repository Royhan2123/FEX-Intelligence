import 'models.dart';
import 'utils.dart';

void generateService(String name, HttpPackage pkg) {
  final className = '${toPascalCase(name)}Service';
  final modelName = '${toPascalCase(name)}Model';
  final fileName = '${name.toLowerCase()}_model.dart';
  final endpoint = name.toLowerCase();
  final buffer = StringBuffer();

  buffer.writeln("import 'dart:convert';");
  buffer.writeln("import '../network/api_client.dart';");
  buffer.writeln("import '../network/endpoints.dart';");
  buffer.writeln("import '../network/network_result.dart';"); // Import Result
  buffer.writeln("import '../models/$fileName';");

  buffer.writeln('\nclass $className {');
  buffer.writeln('  final ApiClient _client;');
  buffer.writeln('  $className(this._client);');

  // 1. FETCH ALL (GET)
  buffer.writeln('\n  Future<NetworkResult<List<$modelName>>> fetch${toPascalCase(name)}s() async {');
  buffer.writeln('    try {');
  buffer.writeln("      final response = await _client.get('/$endpoint');");
  _writeResponseParsing(buffer, pkg, modelName, isList: true);
  buffer.writeln('    } catch (e) {');
  buffer.writeln("      return Failure('Failed to fetch ${name}s: \$e');");
  buffer.writeln('    }');
  buffer.writeln('  }');

  // 2. FETCH BY ID (GET)
  buffer.writeln('\n  Future<NetworkResult<$modelName>> fetch${toPascalCase(name)}ById(String id) async {');
  buffer.writeln('    try {');
  buffer.writeln("      final response = await _client.get('/$endpoint/\$id');");
  _writeResponseParsing(buffer, pkg, modelName, isList: false);
  buffer.writeln('    } catch (e) {');
  buffer.writeln("      return Failure('Failed to fetch $name: \$e');");
  buffer.writeln('    }');
  buffer.writeln('  }');

  // 3. CREATE (POST)
  buffer.writeln('\n  Future<NetworkResult<void>> create${toPascalCase(name)}($modelName data) async {');
  buffer.writeln('    try {');
  buffer.writeln("      await _client.post('/$endpoint', data: data.toJson());");
  buffer.writeln('      return const Success(null);');
  buffer.writeln('    } catch (e) {');
  buffer.writeln("      return Failure('Failed to create $name: \$e');");
  buffer.writeln('    }');
  buffer.writeln('  }');

  // UPDATE & DELETE similar logic
  buffer.writeln('\n  Future<NetworkResult<void>> update${toPascalCase(name)}(String id, $modelName data) async {');
  buffer.writeln('    try {');
  buffer.writeln("      await _client.put('/$endpoint/\$id', data: data.toJson());");
  buffer.writeln('      return const Success(null);');
  buffer.writeln('    } catch (e) { return Failure(\'Failed to update $name: \$e\'); }');
  buffer.writeln('  }');

  buffer.writeln('\n  Future<NetworkResult<void>> delete${toPascalCase(name)}(String id) async {');
  buffer.writeln('    try {');
  buffer.writeln("      await _client.delete('/$endpoint/\$id');");
  buffer.writeln('      return const Success(null);');
  buffer.writeln('    } catch (e) { return Failure(\'Failed to delete $name: \$e\'); }');
  buffer.writeln('  }');

  buffer.writeln('}');
  saveFile('lib/data/services', '${name.toLowerCase()}_service.dart', buffer.toString());
}

void _writeResponseParsing(StringBuffer buffer, HttpPackage pkg, String modelName, {required bool isList}) {
  if (pkg == HttpPackage.dio) {
    if (isList) {
      buffer.writeln('      final list = (response.data as List).map((e) => $modelName.fromJson(e)).toList();');
      buffer.writeln('      return Success(list);');
    } else {
      buffer.writeln('      return Success($modelName.fromJson(response.data));');
    }
  } else if (pkg == HttpPackage.http) {
    buffer.writeln('      final data = jsonDecode(response.body);');
    if (isList) {
      buffer.writeln('      final list = (data as List).map((e) => $modelName.fromJson(e)).toList();');
      buffer.writeln('      return Success(list);');
    } else {
      buffer.writeln('      return Success($modelName.fromJson(data));');
    }
  } else {
    if (isList) {
      buffer.writeln('      final list = (response.body as List).map((e) => $modelName.fromJson(e)).toList();');
      buffer.writeln('      return Success(list);');
    } else {
      buffer.writeln('      return Success($modelName.fromJson(response.body));');
    }
  }
}
