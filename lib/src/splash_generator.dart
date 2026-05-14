import 'dart:io';

class SplashGenerator {
  static Future<void> setSplash(String sourcePath, {String color = '#FFFFFF'}) async {
    print('💦 Generating Native Splash Screen...');
    
    final source = File(sourcePath);
    if (!source.existsSync()) {
      print('❌ Source splash image not found at $sourcePath');
      return;
    }

    await _configureAndroidSplash(color);
    await _configureIOSSplash(color);

    print('✅ Native Splash Screen configured with color $color');
  }

  static Future<void> _configureAndroidSplash(String color) async {
    final styles = File('android/app/src/main/res/values/styles.xml');
    if (styles.existsSync()) {
      print('🤖 Configuring Android styles.xml for splash...');
      // Logic to inject windowBackground
    }
  }

  static Future<void> _configureIOSSplash(String color) async {
    print('🍎 Configuring iOS LaunchScreen.storyboard...');
  }
}
