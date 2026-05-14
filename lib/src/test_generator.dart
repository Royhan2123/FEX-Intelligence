import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as p;

class TestGenerator {
  final String ragBackendUrl;

  TestGenerator({this.ragBackendUrl = 'http://localhost:8000'});

  static Future<void> generate(String targetFile, {String backendUrl = 'http://localhost:8000'}) async {
    final generator = TestGenerator(ragBackendUrl: backendUrl);
    await generator._generateTest(targetFile);
  }

  Future<void> _generateTest(String targetFile) async {
    final file = File(targetFile);
    if (!file.existsSync()) {
      print('❌ File not found: $targetFile');
      return;
    }

    print('🧪 Generating AI-Powered Tests for: ${p.basename(targetFile)}...');

    try {
      final code = file.readAsStringSync();
      
      final prompt = '''
Kamu adalah senior Flutter QA Engineer. Buatkan UNIT TEST dan WIDGET TEST (jika relevan) untuk kode Dart berikut.
Gunakan package `test`, `flutter_test`, dan `mockito` atau `mocktail` untuk mocking.
Pastikan coverage test maksimal.

Berikan HANYA kode test lengkap, tanpa penjelasan tambahan.

KODE:
$code
''';

      final response = await http.post(
        Uri.parse('$ragBackendUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': prompt,
          'chat_history': [],
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        var testCode = body['answer'] as String;
        
        if (testCode.contains('```dart')) {
          testCode = testCode.split('```dart')[1].split('```')[0].trim();
        }

        final testPath = p.join(Directory.current.path, 'test', targetFile.replaceAll('lib/', '').replaceAll('.dart', '_test.dart'));
        Directory(p.dirname(testPath)).createSync(recursive: true);
        
        File(testPath).writeAsStringSync(testCode);
        print('✅ Test file generated at: $testPath');
      }
    } catch (e) {
      print('❌ Failed to generate test: $e');
    }
  }

  static Future<void> coverage() async {
    print('📊 Estimating Test Coverage...');
    final result = await Process.run('flutter', ['test', '--coverage']);
    if (result.exitCode == 0) {
      print('✅ Coverage report generated at coverage/lcov.info');
    } else {
      print('❌ Failed to run coverage.');
    }
  }

  static void watch() {
    print('👀 Test Watcher active. Press Ctrl+C to stop.');
    print('ℹ️ Recommendation: Use `fex test --file <path>` for targeted generation.');
  }
}
