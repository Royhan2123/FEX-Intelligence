import 'dart:io';
import 'package:path/path.dart' as p;
import 'ai_engine.dart';

class TestGenerator {
  static Future<void> generate(String targetFile) async {
    final file = File(targetFile);
    if (!file.existsSync()) {
      print('❌ File not found: $targetFile');
      return;
    }

    print('🧪 Generating AI-Powered Tests (via Gemini) for: ${p.basename(targetFile)}...');

    try {
      final code = file.readAsStringSync();
      final prompt = '''
Kamu adalah senior Flutter QA Engineer. Buatkan UNIT TEST dan WIDGET TEST (jika relevan) untuk kode Dart berikut.
Gunakan package `test`, `flutter_test`, dan `mockito` atau `mocktail` untuk mocking.
Berikan HANYA kode test lengkap, tanpa penjelasan tambahan.

KODE:
$code
''';

      final testCodeRaw = await AIEngine.ask(prompt);
      var testCode = testCodeRaw;
      
      if (testCode.contains('```dart')) {
        testCode = testCode.split('```dart')[1].split('```')[0].trim();
      }

      final testPath = p.join(Directory.current.path, 'test', targetFile.replaceAll('lib/', '').replaceAll('.dart', '_test.dart'));
      Directory(p.dirname(testPath)).createSync(recursive: true);
      
      File(testPath).writeAsStringSync(testCode);
      print('✅ Test file generated at: $testPath');
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
}
