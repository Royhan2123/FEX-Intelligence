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
    File(loggerPath).writeAsStringSync('''
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FexInspector extends Interceptor {
  final String serverUrl = 'http://localhost:8000/network-log';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _sendLog(response);
    super.onResponse(response, handler);
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
      await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(logData),
      );
    } catch (e) {
      print('⚠️ FEX Inspector failed to send log: \$e');
    }
  }
}
''');

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
    final launchFile = File('.vscode/launch.json');
    if (!launchFile.existsSync()) {
      Directory('.vscode').createSync(recursive: true);
      launchFile.writeAsStringSync('{"version": "0.2.0", "configurations": []}');
    }

    // Kita tambahkan "Simple Browser" sebagai post-launch task atau command
    print('✅ Setup VS Code complete.');
    print('\n💡 CARA MELIHAT LOG DI SIDEBAR:');
    print('1. Jalankan aplikasi Flutter kamu.');
    print('2. Di VS Code, tekan Ctrl+Shift+P.');
    print('3. Ketik "Simple Browser: Show".');
    print('4. Masukkan URL: http://localhost:8000/network-inspector');
    print('5. Tarik tab Simple Browser tersebut ke bagian Sidebar (ikon kiri) agar menetap!');
  }
}
