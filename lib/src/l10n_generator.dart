import 'dart:io';
import 'package:path/path.dart' as p;

class L10nGenerator {
  static Future<void> init(List<String> locales) async {
    print('🌍 Initializing Localization for locales: ${locales.join(', ')}...');
    
    final l10nDir = Directory('lib/l10n');
    if (!l10nDir.existsSync()) l10nDir.createSync(recursive: true);

    for (var locale in locales) {
      final file = File(p.join(l10nDir.path, 'app_$locale.arb'));
      if (!file.existsSync()) {
        file.writeAsStringSync('''{
  "@@locale": "$locale",
  "helloWorld": "Hello World!",
  "@helloWorld": {
    "description": "The conventional newborn programmer greeting"
  }
}''');
      }
    }

    _createL10nYaml();
    print('✅ L10n files initialized.');
  }

  static void _createL10nYaml() {
    final file = File('l10n.yaml');
    if (!file.existsSync()) {
      file.writeAsStringSync('''arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
''');
    }
  }

  static Future<void> generate() async {
    print('⚙️ Running flutter gen-l10n...');
    final result = await Process.run('flutter', ['gen-l10n']);
    if (result.exitCode == 0) {
      print('✅ Localization classes generated successfully.');
    } else {
      print('❌ Failed to generate localization: ${result.stderr}');
    }
  }
}
