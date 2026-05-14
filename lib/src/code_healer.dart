import 'dart:io';
import 'package:path/path.dart' as p;
import 'ai_engine.dart';

class CodeHealer {
  static Future<void> run(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      print('❌ File not found: $filePath');
      return;
    }

    print('🩹 AI is performing surgery on: ${p.basename(filePath)}...');
    
    try {
      final code = file.readAsStringSync();
      final prompt = '''
Kamu adalah AI Senior Flutter Developer. Perbaiki error, bug, atau unhandled exception pada kode berikut.
Pastikan kode hasil perbaikan aman, clean, dan mengikuti best practice.
Berikan HANYA kode yang sudah diperbaiki tanpa penjelasan.

KODE ASLI:
$code
''';

      final healedCodeRaw = await AIEngine.ask(prompt);
      var healedCode = healedCodeRaw;

      if (healedCode.contains('```dart')) {
        healedCode = healedCode.split('```dart')[1].split('```')[0].trim();
      }

      // Create backup before overwrite
      final backupFile = File('$filePath.bak');
      backupFile.writeAsStringSync(code);
      
      file.writeAsStringSync(healedCode);
      print('✅ Code healed successfully! Backup created at $filePath.bak');
    } catch (e) {
      print('❌ Healing failed: $e');
    }
  }
}
