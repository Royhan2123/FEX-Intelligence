import 'dart:io';
import 'ai_engine.dart';

class QaAgent {
  static Future<void> run() async {
    print('🤖 Z5 Autonomous QA Agent starting inspection...');
    
    final libDir = Directory('lib');
    if (!libDir.existsSync()) {
      print('❌ lib/ folder not found.');
      return;
    }

    final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
    print('🧐 Inspecting ${files.length} files for logic flaws...');

    for (var file in files.take(3)) { // Limit for demo
      final code = file.readAsStringSync();
      final prompt = 'Sebagai QA Engineer, temukan potensi bug atau bad practice pada kode ini: \n\n $code';
      
      print('🔍 Checking ${file.path}...');
      final review = await AIEngine.ask(prompt);
      print('\n📝 REPORT for ${file.path}:\n$review\n');
    }
    
    print('✅ QA Inspection complete.');
  }
}
