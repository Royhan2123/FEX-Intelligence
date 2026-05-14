import 'dart:io';
import 'ai_engine.dart';

class DepsDoctor {
  static Future<void> run() async {
    print('🩺 FEX Deps Doctor: Analyzing project dependencies...');
    
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) return;

    final pubspec = pubspecFile.readAsStringSync();
    final prompt = 'Analisis dependensi di pubspec.yaml ini. Cari package yang outdated, conflict, atau redundant:\n$pubspec';

    try {
      final report = await AIEngine.ask(prompt);
      print('\n📋 DEPENDENCY REPORT:\n$report');
    } catch (e) {
      print('❌ Failed to analyze dependencies: $e');
    }
  }
}
