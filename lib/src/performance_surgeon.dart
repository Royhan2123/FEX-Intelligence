import 'dart:io';
import 'package:path/path.dart' as p;
import 'ai_engine.dart';

class PerformanceSurgeon {
  static Future<void> optimizeProject() async {
    print('⚡ AI Performance Surgeon: Starting surgical optimization...');
    
    final libDir = Directory('lib');
    if (!libDir.existsSync()) return;

    final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

    for (var file in files) {
      final content = file.readAsStringSync();
      
      // Look for common performance smells
      if (content.contains('ListView(') || content.contains('setState(()')) {
        print('⚡ Optimizing ${p.basename(file.path)}...');
        
        final prompt = '''
Kamu adalah Senior Flutter Performance Expert. Optimalkan kode berikut untuk performa maksimal (gunakan const, kurangi rebuild, optimalkan ListView).
Berikan HANYA kode hasil optimasi tanpa penjelasan.

KODE:
$content
''';

        try {
          final optimizedCodeRaw = await AIEngine.ask(prompt);
          var optimizedCode = optimizedCodeRaw;
          if (optimizedCode.contains('```dart')) {
            optimizedCode = optimizedCode.split('```dart')[1].split('```')[0].trim();
          }
          
          // Backup
          File('${file.path}.bak').writeAsStringSync(content);
          file.writeAsStringSync(optimizedCode);
        } catch (e) {
          print('❌ Failed to optimize ${file.path}: $e');
        }
      }
    }
    print('✅ Performance optimization complete!');
  }

  static Future<void> monitorLive() async {
    print('🩺 [FEX SURGEON] Starting Live Performance Monitoring...');
    print('ℹ️ NOTE: This mode is currently in Simulation Mode for demonstration.');
    
    await Future.delayed(Duration(seconds: 2));
    print('✅ Connected! Monitoring process [PID: $pid]');
    
    await Future.delayed(Duration(seconds: 2));
    print('\n🚨 [CRASH DETECTED] Null check operator used on a null value');
    print('📄 File: home_controller.dart:45');
    
    print('🧠 AI SURGEON: Analyzing Root Cause...');
    final prompt = 'Jelaskan penyebab crash "Null check operator used on a null value" pada baris "var d = storage.get()!;" dan berikan solusinya.';
    final analysis = await AIEngine.ask(prompt);
    print('\n📝 AI ANALYSIS:\n$analysis');
  }
}
