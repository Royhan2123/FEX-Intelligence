import 'dart:io';

class SigningManager {
  static Future<void> generate(String alias, String password) async {
    print('🔑 Generating Android Keystore...');
    
    final keystorePath = 'android/app/upload-keystore.jks';
    final keyPropsPath = 'android/key.properties';

    // 1. Run Keytool
    final result = await Process.run('keytool', [
      '-genkey', '-v',
      '-keystore', keystorePath,
      '-alias', alias,
      '-keyalg', 'RSA',
      '-keysize', '2048',
      '-validity', '10000',
      '-storepass', password,
      '-keypass', password,
      '-dname', 'CN=FEX, OU=Dev, O=FEX, L=ID, S=ID, C=ID'
    ]);

    if (result.exitCode != 0) {
      print('❌ Failed to generate keystore: ${result.stderr}');
      return;
    }

    // 2. Create key.properties
    final propsContent = '''
storePassword=$password
keyPassword=$password
keyAlias=$alias
storeFile=upload-keystore.jks
''';
    File(keyPropsPath).writeAsStringSync(propsContent);
    print('✅ Created $keyPropsPath');

    // 3. Update build.gradle
    await _injectToGradle();
    
    // 4. Update .gitignore
    _updateGitignore();
    
    print('🚀 Keystore generation and configuration complete!');
  }

  static Future<void> _injectToGradle() async {
    final gradleFile = File('android/app/build.gradle');
    if (!gradleFile.existsSync()) return;

    var content = gradleFile.readAsStringSync();
    if (content.contains('signingConfigs')) {
      print('ℹ️ Signing configuration already exists in build.gradle.');
      return;
    }

    final signingLogic = '''
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
''';

    // Prepend to the file or inject at top of android block
    gradleFile.writeAsStringSync(signingLogic + '\n' + content);
    print('✅ Injected signing logic into android/app/build.gradle');
  }

  static void _updateGitignore() {
    final gitignore = File('.gitignore');
    if (gitignore.existsSync()) {
      final content = gitignore.readAsStringSync();
      if (!content.contains('*.jks')) {
        gitignore.writeAsStringSync('\n# Signing Secrets\n*.jks\n*.keystore\nkey.properties\n', mode: FileMode.append);
        print('🛡️ Added keystore files to .gitignore');
      }
    }
  }
}
