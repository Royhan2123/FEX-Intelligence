import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// =============================================
// 🧠 AI TEAM SIMULATION (Point 10)
// =============================================
class TeamSimulation {
  static Future<void> run(String ragUrl) async {
    print('👥 Spawning AI Team (QA, Security, Architect, PM)...');
    final libDir = Directory('lib');
    final List<String> fileNames = [];
    await for (final f in libDir.list(recursive: true)) {
      if (f is File && f.path.endsWith('.dart')) fileNames.add(p.basename(f.path));
    }

    final prompt = '''
Simulasikan review tim untuk project Flutter dengan struktur file berikut: $fileNames.
Berikan feedback dari 4 perspektif:
1. [QA]: Potensi bug logis.
2. [SECURITY]: Celah keamanan.
3. [ARCHITECT]: Kebersihan arsitektur & coupling.
4. [UI/UX]: Konsistensi komponen.

Berikan laporan singkat dan tajam (Global Standard).
''';

    final res = await http.post(Uri.parse('$ragUrl/chat'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': prompt, 'chat_history': []}));

    if (res.statusCode == 200) {
      print('\n🏁 --- TEAM REVIEW REPORT ---');
      print(jsonDecode(res.body)['answer']);
    }
  }
}

// =============================================
// 🤖 AUTONOMOUS REFACTOR AGENT (Point 9)
// =============================================
class RefactorAgent {
  static Future<void> run(String filePath, String ragUrl) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      print('❌ File not found.');
      return;
    }

    print('🤖 Autonomous Refactor Agent starting on: ${p.basename(filePath)}...');
    print('🧩 Strategy: Modularization & Clean Architecture Enforcement...');

    final code = file.readAsStringSync();
    final prompt = '''
Pecah kode Flutter berikut menjadi modul-modul yang lebih kecil sesuai Clean Architecture (Domain, Data, Presentation).
Berikan saran struktur folder baru dan potongan kode yang sudah dipisah.

KODE:
$code
''';

    final res = await http.post(Uri.parse('$ragUrl/chat'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': prompt, 'chat_history': []}));

    if (res.statusCode == 200) {
      print('\n📦 --- REFACTOR STRATEGY ---');
      print(jsonDecode(res.body)['answer']);
    }
  }
}

// =============================================
// 🌍 GLOBAL COMPLIANCE ENGINE (Point 6)
// =============================================
class ComplianceEngine {
  static Future<void> run(String ragUrl) async {
    print('🌍 Scanning for Global Compliance (GDPR, WCAG, EU Act)...');
    final pubspec = File('pubspec.yaml').readAsStringSync();
    
    final prompt = 'Audit project Flutter ini (berdasarkan pubspec) untuk kepatuhan GDPR dan App Store Policy:\n$pubspec';
    final res = await http.post(Uri.parse('$ragUrl/chat'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': prompt, 'chat_history': []}));

    if (res.statusCode == 200) {
      print('\n⚖️ --- COMPLIANCE SCORE ---');
      print(jsonDecode(res.body)['answer']);
    }
  }
}
