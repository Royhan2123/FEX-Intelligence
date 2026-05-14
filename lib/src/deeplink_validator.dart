import 'dart:io';

class DeeplinkValidator {
  static Future<void> check() async {
    print('🔗 Validating Deep Links (Android & iOS)...');
    
    _checkAndroid();
    _checkIOS();
    
    print('✅ Deep link validation complete. Run "fex deeplink report" for details.');
  }

  static void _checkAndroid() {
    final manifest = File('android/app/src/main/AndroidManifest.xml');
    if (!manifest.existsSync()) return;

    final content = manifest.readAsStringSync();
    if (content.contains('android:scheme') || content.contains('android:host')) {
      print('✅ Android Deep Links detected in AndroidManifest.xml');
    } else {
      print('⚠️ No Deep Links found for Android.');
    }
  }

  static void _checkIOS() {
    final infoPlist = File('ios/Runner/Info.plist');
    if (!infoPlist.existsSync()) return;

    final content = infoPlist.readAsStringSync();
    if (content.contains('CFBundleURLSchemes')) {
      print('✅ iOS URL Schemes detected in Info.plist');
    } else {
      print('⚠️ No URL Schemes found for iOS.');
    }
  }
}
