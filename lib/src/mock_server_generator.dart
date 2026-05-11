import 'dart:io';
import 'package:path/path.dart' as p;

class MockServerGenerator {
  static Future<void> generate() async {
    print('🌐 Generating Local Mock Server (Dart Based)...');

    final serverDir = p.join(Directory.current.path, 'mock_server');
    Directory(serverDir).createSync(recursive: true);

    final serverFile = File(p.join(serverDir, 'server.dart'));
    serverFile.writeAsStringSync('''
import 'dart:convert';
import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
  print('🚀 Mock Server running on http://localhost:3000');

  await for (HttpRequest request in server) {
    print('Incoming request: \${request.method} \${request.uri.path}');
    
    // Default Response
    request.response
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({
        'status': 'success',
        'message': 'Hello from Mock Server!',
        'data': [
          {'id': 1, 'name': 'Test Data 1'},
          {'id': 2, 'name': 'Test Data 2'},
        ]
      }))
      ..close();
  }
}
''');

    print('\n✅ Mock Server generated in ./mock_server/server.dart');
    print('💡 Run it with: `dart mock_server/server.dart`');
  }
}
