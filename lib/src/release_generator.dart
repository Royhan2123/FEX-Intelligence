import 'dart:io';

class ReleaseGenerator {
  static Future<void> generate(String type) async {
    print('🚀 Preparing $type release...');
    
    final version = await _bumpVersion(type);
    await _generateChangelog(version);
    
    print('✅ Release $version ready! Tagging git...');
    await Process.run('git', ['tag', '-a', 'v$version', '-m', 'Release $version']);
  }

  static Future<String> _bumpVersion(String type) async {
    final pubspec = File('pubspec.yaml');
    var content = pubspec.readAsStringSync();
    
    final versionRegExp = RegExp(r'version: (\d+)\.(\d+)\.(\d+)(?:\+(\d+))?');
    final match = versionRegExp.firstMatch(content);
    
    if (match != null) {
      int major = int.parse(match.group(1)!);
      int minor = int.parse(match.group(2)!);
      int patch = int.parse(match.group(3)!);
      int build = int.parse(match.group(4) ?? '0');

      if (type == 'major') {
        major++;
      } else if (type == 'minor') {
        minor++;
      } else {
        patch++;
      }
      
      build++;

      final newVersion = '$major.$minor.$patch+$build';
      content = content.replaceFirst(versionRegExp, 'version: $newVersion');
      pubspec.writeAsStringSync(content);
      return newVersion;
    }
    return '1.0.0+1';
  }

  static Future<void> _generateChangelog(String version) async {
    final changelog = File('CHANGELOG.md');
    final now = DateTime.now().toIso8601String().split('T')[0];
    
    final newEntry = '## [$version] - $now\n- Auto-generated release by FEX CLI\n\n';
    
    if (changelog.existsSync()) {
      final oldContent = changelog.readAsStringSync();
      changelog.writeAsStringSync(newEntry + oldContent);
    } else {
      changelog.writeAsStringSync('# CHANGELOG\n\n$newEntry');
    }
    print('✅ CHANGELOG.md updated.');
  }
}
