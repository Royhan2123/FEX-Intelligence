import 'utils.dart';

void generateNetworkResult() {
  const content = '''
sealed class NetworkResult<T> {
  const NetworkResult();
}

class Success<T> extends NetworkResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends NetworkResult<T> {
  final String message;
  const Failure(this.message);
}

class Loading<T> extends NetworkResult<T> {
  const Loading();
}
''';
  saveFile('lib/data/network', 'network_result.dart', content);
}

void generateInjection(List<String> features) {
  final buffer = StringBuffer();
  buffer.writeln("import 'package:get_it/get_it.dart';");
  buffer.writeln("import 'data/network/api_client.dart';");
  
  for (var feature in features) {
    final name = feature.toLowerCase();
    buffer.writeln("import 'data/services/${name}_service.dart';");
    buffer.writeln("import 'data/repositories/${name}_repository.dart';");
  }

  buffer.writeln('\nfinal getIt = GetIt.instance;');
  buffer.writeln('\nFuture<void> init() async {');
  buffer.writeln('  // Network');
  buffer.writeln('  getIt.registerLazySingleton(() => ApiClient());');

  for (var feature in features) {
    final pascal = feature[0].toUpperCase() + feature.substring(1);
    buffer.writeln('\n  // $pascal Feature');
    buffer.writeln('  getIt.registerLazySingleton(() => ${pascal}Service(getIt()));');
    buffer.writeln('  getIt.registerLazySingleton(() => ${pascal}Repository(getIt()));');
  }

  buffer.writeln('}');

  saveFile('lib', 'injection.dart', buffer.toString());
}
