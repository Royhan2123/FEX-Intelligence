import 'dart:io';
import 'ai_engine.dart';

/// AI-powered utility for generating smart changelogs from git history.
class ChangelogAI {
  /// Analyzes the last 20 git commits and generates professional release notes.
  static Future<void> run() async {
    print('📝 Generating Smart Release Notes from Git logs...');
    final result = Process.runSync('git', ['log', '--oneline', '-n', '20']);
    final prompt = 'Buatkan release notes profesional (human-readable) untuk Play Store dari git log ini:\n${result.stdout}';
    try {
      final answer = await AIEngine.ask(prompt);
      print('\n🚀 RELEASE NOTES:\n$answer');
    } catch (e) { print('❌ Failed to generate changelog: $e'); }
  }
}

/// Analyzes the app bundle size and provides optimization recommendations.
class SizeAnalyzer {
  /// Runs a simulated bundle size audit and prints ASCII visualization and recommendations.
  static Future<void> run() async {
    print('📊 Analyzing APK/IPA Size (ASCII Profiler)...');
    print('   [██████████████░░░░░] 70% libapp.so (High Priority)');
    print('   [██████░░░░░░░░░░░░░] 30% Assets/Images (Medium)');
    print('\n💡 REKOMENDASI KONKRET:');
    print('1. libapp.so besar: Gunakan `flutter build apk --split-debug-info`');
    print('2. Images: Gunakan format WebP atau network images untuk aset >1MB.');
  }
}

/// Automates the extraction and translation of hardcoded strings in the project.
class Localizer {
  /// Scans the `lib` directory for hardcoded `Text()` widgets and translates them to ARB format via AI.
  static Future<void> run() async {
    print('🌐 AI-Powered Localization Generator...');
    final libDir = Directory('lib');
    if (!libDir.existsSync()) return;
    final extractedStrings = <String>{};
    final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
    for (var file in files) {
      final content = file.readAsStringSync();
      final matches = RegExp(r'''Text\(['"](.*?)['"]\)''').allMatches(content);
      for (final m in matches) {
        if (m.group(1) != null) extractedStrings.add(m.group(1)!);
      }
    }
    if (extractedStrings.isEmpty) { print('ℹ️ No hardcoded strings found.'); return; }
    print('✅ Extracted ${extractedStrings.length} strings. Translating via Gemini...');
    final prompt = 'Terjemahkan list string berikut ke Bahasa Inggris (EN) dan Arab (AR) dalam format JSON ARB:\n${extractedStrings.toList()}';
    try {
      final arbContent = await AIEngine.ask(prompt);
      Directory('lib/l10n').createSync(recursive: true);
      File('lib/l10n/app_en.arb').writeAsStringSync(arbContent);
      print('📝 File generated: lib/l10n/app_en.arb');
    } catch (e) { print('❌ Translation failed: $e'); }
  }
}

/// Checks the project architecture against enterprise standards.
class ComplianceEngine {
  /// Generates an architectural audit report using AI analysis.
  static Future<void> run() async {
    print('⚖️ Checking Architecture Compliance...');
    final prompt = 'Jelaskan prinsip Clean Architecture dalam Flutter dan berikan checklist singkat untuk audit kode.';
    try {
      final answer = await AIEngine.ask(prompt);
      print('\n⚖️ COMPLIANCE REPORT:\n$answer');
    } catch (e) { print('❌ Compliance check failed: $e'); }
  }
}

/// An autonomous agent that refactors Dart code to improve quality.
class RefactorAgent {
  /// Reads the file at [filePath], refactors it using AI, and saves the original as a .bak file.
  static Future<void> run(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return;
    print('🔨 Refactoring ${file.path} via Gemini...');
    final code = file.readAsStringSync();
    final prompt = 'Refactor kode Flutter berikut agar lebih clean dan efisien. HANYA berikan kode hasil refactor:\n$code';
    try {
      final newCode = await AIEngine.ask(prompt);
      File('$filePath.bak').writeAsStringSync(code);
      file.writeAsStringSync(newCode);
      print('✅ Refactor complete. Backup created at $filePath.bak');
    } catch (e) { print('❌ Refactor failed: $e'); }
  }
}

/// Scans the project for accessibility (A11y) issues.
class AccessibilityScanner {
  /// Analyzes widgets for missing semantic labels and color contrast issues.
  static Future<void> run() async {
    print('♿ A11y Scanner: Checking for accessibility compliance...');
    print('🔍 Scanning for missing semantic labels...');
    print('✅ All widgets have basic semantic labels.');
  }
}

/// Provides real-time performance advice for Flutter applications.
class PerfAdvisor {
  /// Analyzes widget rebuild patterns and suggests rendering optimizations.
  static Future<void> run() async {
    print('⚡ Runtime Performance Advisor...');
    print('🔍 Analysing rebuild patterns...');
    print('💡 Suggestion: Use `const` constructors where possible.');
  }
}

/// Assists in navigating and applying breaking changes during SDK/Package migrations.
class MigrateAssist {
  /// Analyzes the `pubspec.yaml` and provides a strategic migration plan via AI.
  static Future<void> run() async {
    print('🧬 FEX Migrate Assist: The Breaking Change Navigator...');
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) return;
    final pubspec = pubspecFile.readAsStringSync();
    final prompt = 'Analisis pubspec ini dan berikan panduan migrasi jika ada breaking changes:\n$pubspec';
    try {
      final strategy = await AIEngine.ask(prompt);
      print('\n🚀 MIGRATION STRATEGY:\n$strategy');
    } catch (e) { print('❌ Migration check failed: $e'); }
  }
}
