import 'dart:io';

class PermissionManager {
  static final Map<String, Map<String, String>> _permissionMap = {
    'camera': {
      'android': '<uses-permission android:name="android.permission.CAMERA" />',
      'ios': '<key>NSCameraUsageDescription</key>\n<string>We need camera access for...</string>'
    },
    'location': {
      'android': '<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />',
      'ios': '<key>NSLocationWhenInUseUsageDescription</key>\n<string>We need location access for...</string>'
    },
    'microphone': {
      'android': '<uses-permission android:name="android.permission.RECORD_AUDIO" />',
      'ios': '<key>NSMicrophoneUsageDescription</key>\n<string>We need microphone access for...</string>'
    }
  };

  static Future<void> add(List<String> permissions) async {
    for (var p in permissions) {
      final perm = p.toLowerCase();
      if (_permissionMap.containsKey(perm)) {
        print('🛡️ Adding permission: $perm...');
        await _injectAndroid(perm);
        await _injectIOS(perm);
      } else {
        print('⚠️ Unknown permission: $perm');
      }
    }
    print('✅ Permissions injected successfully!');
  }

  static Future<void> _injectAndroid(String type) async {
    final manifest = File('android/app/src/main/AndroidManifest.xml');
    if (!manifest.existsSync()) return;

    var content = manifest.readAsStringSync();
    final tag = _permissionMap[type]!['android']!;
    
    if (!content.contains(tag)) {
      content = content.replaceFirst('<manifest', '$tag\n<manifest');
      manifest.writeAsStringSync(content);
    }
  }

  static Future<void> _injectIOS(String type) async {
    final plist = File('ios/Runner/Info.plist');
    if (!plist.existsSync()) return;

    var content = plist.readAsStringSync();
    final tag = _permissionMap[type]!['ios']!;
    
    if (!content.contains(tag.split('\n').first)) {
      content = content.replaceFirst('<dict>', '<dict>\n$tag');
      plist.writeAsStringSync(content);
    }
  }
}
