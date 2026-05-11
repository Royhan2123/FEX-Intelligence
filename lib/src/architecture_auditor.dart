import 'dart:io';
import 'package:path/path.dart' as p;

class ArchitectureAuditor {
  static void audit() {
    print('🔍 Auditing Architecture & Code Quality...');

    final libDir = Directory(p.join(Directory.current.path, 'lib'));
    if (!libDir.existsSync()) {
      print('❌ lib folder not found.');
      return;
    }

    int issuesFound = 0;

    libDir.listSync(recursive: true).forEach((entity) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
        final fileName = p.basename(entity.path);

        // Rule 1: Print statements check
        if (content.contains('print(')) {
          print('  ⚠️ [STYLING] Avoid using print() in production: $fileName');
          issuesFound++;
        }

        // Rule 2: Controller dispose check (This rule is GetX specific and doesn't apply here)
        // The original code does not use GetxController, so no change is needed for this rule.

        // Rule 3: Hardcoded API URLs
        if (content.contains('http://') || content.contains('https://')) {
          if (!entity.path.contains('config') && !entity.path.contains('api')) {
             print('  ⚠️ [SECURITY] Hardcoded URL found outside config files: $fileName');
             issuesFound++;
          }
        }
      }
    });

    print('\n✅ Audit Complete. Issues found: $issuesFound');
  }
}