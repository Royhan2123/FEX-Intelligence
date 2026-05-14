import 'dart:io';
import 'package:path/path.dart' as p;

class FlavorGenerator {
  static Future<void> init() async {
    print('🎨 Initializing Flutter Flavors (Android & iOS)...');
    
    await _setupAndroid();
    await _setupIOS();
    await _createMainFiles();
    
    print('✨ Flavor initialization complete!');
  }

  static Future<void> _setupAndroid() async {
    final buildGradle = File('android/app/build.gradle');
    if (!buildGradle.existsSync()) return;

    var content = buildGradle.readAsStringSync();
    
    if (content.contains('productFlavors')) {
      print('ℹ️ Android Flavors already configured.');
      return;
    }

    final flavorConfig = '''
    flavorDimensions "default"
    productFlavors {
        dev {
            dimension "default"
            resValue "string", "app_name", "FEX App Dev"
            applicationIdSuffix ".dev"
        }
        staging {
            dimension "default"
            resValue "string", "app_name", "FEX App Staging"
            applicationIdSuffix ".staging"
        }
        prod {
            dimension "default"
            resValue "string", "app_name", "FEX App"
        }
    }
''';

    // Insert before buildTypes or at end of android block
    content = content.replaceFirst('buildTypes {', '$flavorConfig\n    buildTypes {');
    buildGradle.writeAsStringSync(content);
    print('✅ Android build.gradle updated.');

    await _updateManifest();
  }

  static Future<void> _updateManifest() async {
    final manifest = File('android/app/src/main/AndroidManifest.xml');
    if (!manifest.existsSync()) return;

    var content = manifest.readAsStringSync();
    final labelRegex = RegExp(r'android:label="([^"]+)"');
    
    if (content.contains('android:label="@string/app_name"')) {
      print('ℹ️ AndroidManifest already using @string/app_name.');
      return;
    }

    content = content.replaceFirst(labelRegex, 'android:label="@string/app_name"');
    manifest.writeAsStringSync(content);
    print('✅ AndroidManifest.xml updated to use flavor-based app name.');
  }

  static Future<void> _setupIOS() async {
    print('ℹ️ For iOS, FEX recommends using xcconfig files. Creating templates...');
    final iosDir = Directory('ios/Flutter');
    if (!iosDir.existsSync()) return;

    final flavors = ['Debug-dev', 'Release-dev', 'Debug-staging', 'Release-staging', 'Debug-prod', 'Release-prod'];
    for (var f in flavors) {
      final file = File(p.join(iosDir.path, '$f.xcconfig'));
      if (!file.existsSync()) {
        file.writeAsStringSync('#include "Generated.xcconfig"\n#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.$f.xcconfig"\n\nAPP_NAME = FEX ${f.split('-').last}\n');
      }
    }
    print('✅ iOS xcconfig templates created.');
  }

  static Future<void> _createMainFiles() async {
    final libDir = Directory('lib');
    final flavors = ['dev', 'staging', 'prod'];
    
    for (var f in flavors) {
      final file = File(p.join(libDir.path, 'main_$f.dart'));
      if (!file.existsSync()) {
        file.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'main.dart' as runner;

void main() {
  // Configure for $f environment
  runner.main();
}
''');
      }
    }
    print('✅ main_flavor files created in lib/');
  }
}
