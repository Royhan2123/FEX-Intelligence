import 'dart:io';
import 'ai_engine.dart';

class EvolveEngine {
  static Future<void> run(String from, String to, {String? backendUrl}) async {
    print('🧬 Evolving Architecture from $from to $to...');
    
    final libDir = Directory('lib');
    if (!libDir.existsSync()) return;

    final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

    for (var file in files) {
      print('Transforming ${file.path}...');
      final code = file.readAsStringSync();
      
      final prompt = '''
Kamu adalah senior Flutter Architect. Ubah arsitektur kode berikut dari $from menjadi $to.
Pertahankan semua business logic. HANYA berikan kode hasil transformasi tanpa penjelasan.

KODE:
$code
''';

      try {
        final evolvedCodeRaw = await AIEngine.ask(prompt);
        var evolvedCode = evolvedCodeRaw;
        
        if (evolvedCode.contains('```dart')) {
          evolvedCode = evolvedCode.split('```dart')[1].split('```')[0].trim();
        }

        // Backup
        File('${file.path}.bak').writeAsStringSync(code);
        
        file.writeAsStringSync(evolvedCode);
      } catch (e) {
        print('❌ Failed to evolve ${file.path}: $e');
      }
    }
    
    print('✅ Architecture evolution complete! Backups created for all files.');
  }
}