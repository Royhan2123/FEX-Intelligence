import 'dart:io';

class ProjectRenamer {
  static Future<void> rename(String newPackageName) async {
    print('🏷️ Renaming project to: $newPackageName...');
    
    await _renameAndroid(newPackageName);
    await _renameIOS(newPackageName);
    
    print('✅ Project successfully renamed to $newPackageName');
  }

  static Future<void> _renameAndroid(String newName) async {
    // 1. Update build.gradle
    final gradle = File('android/app/build.gradle');
    if (gradle.existsSync()) {
      var content = gradle.readAsStringSync();
      content = content.replaceFirst(RegExp(r'applicationId "([^"]+)"'), 'applicationId "$newName"');
      gradle.writeAsStringSync(content);
    }

    // 2. Update AndroidManifest.xml
    final manifestPath = 'android/app/src/main/AndroidManifest.xml';
    final manifest = File(manifestPath);
    if (manifest.existsSync()) {
      var content = manifest.readAsStringSync();
      content = content.replaceFirst(RegExp(r'package="([^"]+)"'), 'package="$newName"');
      manifest.writeAsStringSync(content);
    }

    print('✅ Android package name updated.');
  }

  static Future<void> _renameIOS(String newName) async {
    final pbxproj = File('ios/Runner.xcodeproj/project.pbxproj');
    if (pbxproj.existsSync()) {
      var content = pbxproj.readAsStringSync();
      content = content.replaceAll(RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);'), 'PRODUCT_BUNDLE_IDENTIFIER = $newName;');
      pbxproj.writeAsStringSync(content);
      print('✅ iOS bundle identifier updated.');
    }
  }
}
