import 'dart:io';
import 'package:path/path.dart' as p;

class LogInjector {
  static Future<void> run() async {
    print('🔍 Scanning for Network Clients...');
    final libDir = Directory('lib');
    File? networkFile;

    await for (final f in libDir.list(recursive: true)) {
      if (f is File && f.path.endsWith('.dart')) {
        final content = f.readAsStringSync();
        if (content.contains('Dio(')) {
          networkFile = f;
          break;
        }
      }
    }

    if (networkFile == null) {
      print('⚠️ Hanya mendukung Dio saat ini. Inisialisasi Dio() tidak ditemukan.');
      return;
    }

    stdout.write('🛰️ Inject FEX Global Inspector (with VS Code Sidebar)? (y/n): ');
    final res = stdin.readLineSync()?.toLowerCase();
    if (res == 'y') {
      await _injectAdvanced(networkFile);
      await _setupVSCodeSidebar();
    }
  }

  static Future<void> _injectAdvanced(File networkFile) async {
    final loggerPath = p.join(p.dirname(networkFile.path), 'fex_inspector.dart');
    
    // KODE INI DISIMPAN SEBAGAI STRING AGAR TIDAK ERROR DI PROJECT CLI
    final String inspectorCode = r'''
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class FexInspector extends Interceptor {
  final String serverUrl = 'http://localhost:8000/network-log';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _sendLog(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) _sendLog(err.response!);
    super.onError(err, handler);
  }

  void _sendLog(Response res) async {
    try {
      final logData = {
        'method': res.requestOptions.method,
        'url': res.requestOptions.uri.toString(),
        'status': res.statusCode,
        'request_body': res.requestOptions.data,
        'response_body': res.data,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final client = HttpClient();
      final request = await client.postUrl(Uri.parse(serverUrl));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(logData)));
      await request.close();
      client.close();
    } catch (e) { }
  }
}
''';

    File(loggerPath).writeAsStringSync(inspectorCode);

    var content = networkFile.readAsStringSync();
    if (!content.contains('FexInspector()')) {
      content = "import 'fex_inspector.dart';\n" + content;
      content = content.replaceFirst('Dio(', 'Dio()..interceptors.add(FexInspector()) // ');
      networkFile.writeAsStringSync(content);
      print('✅ Advanced Inspector injected.');
    }
  }

  static Future<void> _setupVSCodeSidebar() async {
    print('🔗 Integrating with VS Code Sidebar...');
    // Logika VS Code tetap sama...
    print('✅ Setup VS Code complete.');
  }
}
