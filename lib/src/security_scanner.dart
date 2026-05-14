import 'dart:io';
import 'package:path/path.dart' as p;

// =============================================
//  Severity Levels
// =============================================
enum Severity { critical, high, medium, low, info }

class SecurityIssue {
  final Severity severity;
  final String rule;
  final String description;
  final String file;
  final int? line;
  final String? snippet;

  SecurityIssue({
    required this.severity,
    required this.rule,
    required this.description,
    required this.file,
    this.line,
    this.snippet,
  });
}

// =============================================
//  Security Penetration Scanner
// =============================================
class SecurityPentestScanner {
  final List<SecurityIssue> _issues = [];
  int _filesScanned = 0;

  static Future<void> run() async {
    final scanner = SecurityPentestScanner();
    await scanner._scan();
  }

  Future<void> _scan() async {
    final libDir = Directory(p.join(Directory.current.path, 'lib'));

    if (!libDir.existsSync()) {
      print('❌ lib/ folder not found. Run this from your Flutter project root.');
      return;
    }

    _printBanner();

    // Scan all dart files
    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        _filesScanned++;
        final content = entity.readAsStringSync();
        final lines = content.split('\n');
        final fileName = entity.path.replaceAll(Directory.current.path, '');

        _checkHardcodedSecrets(content, lines, fileName);
        _checkInsecureStorage(content, lines, fileName);
        _checkHttpWithoutPinning(content, lines, fileName);
        _checkSqlInjection(content, lines, fileName);
        _checkWeakCrypto(content, lines, fileName);
        _checkInsecureLogging(content, lines, fileName);
        _checkExposedDebugCode(content, lines, fileName);
        _checkInsecureRandomness(content, lines, fileName);
      }
    }

    // Also scan pubspec.yaml for vulnerable packages
    _checkPubspec();

    _printReport();
  }

  // --- RULE 1: Hardcoded Secrets ---
  void _checkHardcodedSecrets(String content, List<String> lines, String file) {
    final patterns = [
      RegExp(r'''(?:api_?key|apiKey|API_KEY)\s*[:=]\s*["'][^"']{8,}["']''', caseSensitive: false),
      RegExp(r'''(?:password|passwd|secret)\s*[:=]\s*["'][^"']{4,}["']''', caseSensitive: false),
      RegExp(r'''Bearer\s+[A-Za-z0-9\-_.]+''', caseSensitive: false),
      RegExp(r'''AIza[0-9A-Za-z\-_]{35}'''),
      RegExp(r'''sk-[A-Za-z0-9]{20,}'''),
    ];

    for (var i = 0; i < lines.length; i++) {
      for (final pattern in patterns) {
        if (pattern.hasMatch(lines[i])) {
          _addIssue(SecurityIssue(
            severity: Severity.critical,
            rule: 'HARDCODED_SECRET',
            description: 'Hardcoded secret/API key ditemukan! Pindahkan ke .env atau flutter_secure_storage.',
            file: file,
            line: i + 1,
            snippet: lines[i].trim(),
          ));
        }
      }
    }
  }

  // --- RULE 2: Insecure Storage ---
  void _checkInsecureStorage(String content, List<String> lines, String file) {
    final insecurePatterns = [
      RegExp(r'''SharedPreferences.*(?:token|secret|password|key)''', caseSensitive: false),
      RegExp(r'''setString\s*\(\s*["'](?:token|auth|key|secret|password)["']''', caseSensitive: false),
    ];

    for (var i = 0; i < lines.length; i++) {
      for (final pattern in insecurePatterns) {
        if (pattern.hasMatch(lines[i])) {
          _addIssue(SecurityIssue(
            severity: Severity.critical,
            rule: 'INSECURE_STORAGE',
            description: 'Token/secret tersimpan di SharedPreferences (tidak terenkripsi!). Gunakan flutter_secure_storage.',
            file: file,
            line: i + 1,
            snippet: lines[i].trim(),
          ));
        }
      }
    }
  }

  // --- RULE 3: HTTP Without Certificate Pinning ---
  void _checkHttpWithoutPinning(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('Uri.http(') || lines[i].contains("'http://")) {
        _addIssue(SecurityIssue(
          severity: Severity.high,
          rule: 'INSECURE_HTTP',
          description: 'Koneksi HTTP (bukan HTTPS) ditemukan. Rentan terhadap Man-in-the-Middle attack.',
          file: file,
          line: i + 1,
          snippet: lines[i].trim(),
        ));
      }

      // Check for disabled SSL verification
      if (lines[i].contains('badCertificateCallback') && lines[i].contains('true')) {
        _addIssue(SecurityIssue(
          severity: Severity.critical,
          rule: 'SSL_VERIFICATION_DISABLED',
          description: 'Verifikasi SSL dinonaktifkan! Sangat berbahaya di production.',
          file: file,
          line: i + 1,
          snippet: lines[i].trim(),
        ));
      }
    }
  }

  // --- RULE 4: SQL Injection Risk ---
  void _checkSqlInjection(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      // Raw string interpolation in SQL queries
      if ((lines[i].contains('rawQuery') || lines[i].contains('execute(')) &&
          lines[i].contains(r'$')) {
        _addIssue(SecurityIssue(
          severity: Severity.high,
          rule: 'SQL_INJECTION_RISK',
          description: 'String interpolation dalam raw SQL query. Gunakan parameterized queries (?)',
          file: file,
          line: i + 1,
          snippet: lines[i].trim(),
        ));
      }
    }
  }

  // --- RULE 5: Weak Cryptography ---
  void _checkWeakCrypto(String content, List<String> lines, String file) {
    final weakPatterns = [
      RegExp(r'MD5\s*\('),
      RegExp(r'sha1\s*\(', caseSensitive: false),
      RegExp(r'DES\s*\('),
    ];
    for (var i = 0; i < lines.length; i++) {
      for (final pattern in weakPatterns) {
        if (pattern.hasMatch(lines[i])) {
          _addIssue(SecurityIssue(
            severity: Severity.high,
            rule: 'WEAK_CRYPTOGRAPHY',
            description: 'Algoritma kriptografi lemah (MD5/SHA1/DES). Gunakan SHA-256 atau AES-256.',
            file: file,
            line: i + 1,
            snippet: lines[i].trim(),
          ));
        }
      }
    }
  }

  // --- RULE 6: Sensitive Data in Logs ---
  void _checkInsecureLogging(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      if ((lines[i].contains('print(') || lines[i].contains('log(')) &&
          RegExp(r'(?:token|password|secret|key|auth)', caseSensitive: false).hasMatch(lines[i])) {
        _addIssue(SecurityIssue(
          severity: Severity.medium,
          rule: 'SENSITIVE_DATA_LOGGED',
          description: 'Data sensitif mungkin ter-log. Hapus log yang mengandung token/password.',
          file: file,
          line: i + 1,
          snippet: lines[i].trim(),
        ));
      }
    }
  }

  // --- RULE 7: Debug Code in Production ---
  void _checkExposedDebugCode(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('kDebugMode') && lines[i].contains('==') && lines[i].contains('false')) {
        continue; // intentionally disabled
      }
      if (lines[i].trim().startsWith('debugPrint(') || lines[i].contains('FlutterError.onError')) {
        // just informational
      }
      // Check for backdoor-like conditions
      if (RegExp(r'if\s*\(\s*(?:true|1\s*==\s*1)\s*\)').hasMatch(lines[i])) {
        _addIssue(SecurityIssue(
          severity: Severity.medium,
          rule: 'ALWAYS_TRUE_CONDITION',
          description: 'Kondisi yang selalu true ditemukan. Mungkin bypass keamanan yang tidak disengaja.',
          file: file,
          line: i + 1,
          snippet: lines[i].trim(),
        ));
      }
    }
  }

  // --- RULE 8: Insecure Randomness ---
  void _checkInsecureRandomness(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('math.Random()') && 
          RegExp(r'(?:token|session|id|key|nonce)', caseSensitive: false).hasMatch(content)) {
        _addIssue(SecurityIssue(
          severity: Severity.medium,
          rule: 'INSECURE_RANDOM',
          description: 'math.Random() tidak aman untuk kebutuhan kriptografi. Gunakan dart:math Random.secure().',
          file: file,
          line: i + 1,
          snippet: lines[i].trim(),
        ));
      }
    }
  }

  // --- RULE 9: Check pubspec for known vulnerable packages ---
  void _checkPubspec() {
    final pubspec = File(p.join(Directory.current.path, 'pubspec.yaml'));
    if (!pubspec.existsSync()) return;

    final content = pubspec.readAsStringSync();
    // Packages known to have had critical vulnerabilities
    final riskyPackages = ['http: ^0.', 'xml: ^3.', 'crypto: ^2.'];
    for (final pkg in riskyPackages) {
      if (content.contains(pkg)) {
        _addIssue(SecurityIssue(
          severity: Severity.medium,
          rule: 'OUTDATED_DEPENDENCY',
          description: 'Package versi lama terdeteksi: "$pkg". Update ke versi terbaru.',
          file: 'pubspec.yaml',
          line: null,
          snippet: pkg,
        ));
      }
    }
  }

  void _addIssue(SecurityIssue issue) => _issues.add(issue);

  void _printBanner() {
    print('');
    print('╔══════════════════════════════════════════════════╗');
    print('║   🕵️  SECURITY PENETRATION SCANNER               ║');
    print('║   Powered by flutter_cli_generate                ║');
    print('╚══════════════════════════════════════════════════╝');
    print('');
    print('📂 Scanning: ${Directory.current.path}');
    print('');
  }

  void _printReport() {
    // Group by severity
    final critical = _issues.where((i) => i.severity == Severity.critical).toList();
    final high = _issues.where((i) => i.severity == Severity.high).toList();
    final medium = _issues.where((i) => i.severity == Severity.medium).toList();
    final low = _issues.where((i) => i.severity == Severity.low).toList();

    if (_issues.isEmpty) {
      print('✅ No security issues found! Your code looks clean.');
    } else {
      if (critical.isNotEmpty) {
        print('🚨 CRITICAL (${critical.length})');
        print('─' * 50);
        for (final issue in critical) {
          _printIssue(issue);
        }
      }
      if (high.isNotEmpty) {
        print('\n🔴 HIGH (${high.length})');
        print('─' * 50);
        for (final issue in high) {
          _printIssue(issue);
        }
      }
      if (medium.isNotEmpty) {
        print('\n🟡 MEDIUM (${medium.length})');
        print('─' * 50);
        for (final issue in medium) {
          _printIssue(issue);
        }
      }
      if (low.isNotEmpty) {
        print('\n🟢 LOW (${low.length})');
        print('─' * 50);
        for (final issue in low) {
          _printIssue(issue);
        }
      }
    }

    print('');
    print('═' * 52);
    print('  📊 Files scanned    : $_filesScanned');
    print('  🚨 Critical         : ${critical.length}');
    print('  🔴 High             : ${high.length}');
    print('  🟡 Medium           : ${medium.length}');
    print('  🟢 Low              : ${low.length}');
    print('  📋 Total issues     : ${_issues.length}');
    print('═' * 52);
    print('');

    // Write report to file
    _writeReportToFile(critical, high, medium, low);
  }

  void _printIssue(SecurityIssue issue) {
    print('  [${issue.rule}]');
    print('  📄 ${issue.file}${issue.line != null ? ':${issue.line}' : ''}');
    print('  💬 ${issue.description}');
    if (issue.snippet != null && issue.snippet!.isNotEmpty) {
      print('  🔍 ${issue.snippet!.substring(0, issue.snippet!.length.clamp(0, 80))}');
    }
    print('');
  }

  void _writeReportToFile(List critical, List high, List medium, List low) {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').substring(0, 19);
    final reportFile = File('security_report_$timestamp.md');

    final buffer = StringBuffer();
    buffer.writeln('# 🕵️ Security Scan Report');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('\n## Summary');
    buffer.writeln('| Severity | Count |');
    buffer.writeln('|---|---|');
    buffer.writeln('| 🚨 Critical | ${critical.length} |');
    buffer.writeln('| 🔴 High | ${high.length} |');
    buffer.writeln('| 🟡 Medium | ${medium.length} |');
    buffer.writeln('| Total | ${_issues.length} |');

    for (final issue in _issues) {
      buffer.writeln('\n---');
      buffer.writeln('**[${issue.severity.name.toUpperCase()}] ${issue.rule}**');
      buffer.writeln('- File: `${issue.file}${issue.line != null ? ':${issue.line}' : ''}`');
      buffer.writeln('- Description: ${issue.description}');
      if (issue.snippet != null) buffer.writeln('- Code: `${issue.snippet}`');
    }

    reportFile.writeAsStringSync(buffer.toString());
    print('📝 Full report saved to: ${reportFile.path}');
  }
}
