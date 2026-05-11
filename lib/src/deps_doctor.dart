import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as p;

class DepsDoctor {
  final String ragBackendUrl;

  DepsDoctor({this.ragBackendUrl = 'http://localhost:8000'});

  static Future<void> run({String backendUrl = 'http://localhost:8000'}) async {
    final doctor = DepsDoctor(ragBackendUrl: backendUrl);
    await doctor._analyzeDependencies();
  }

  Future<void> _analyzeDependencies() async {
    print('🕵️ Analyzing dependencies for "Abandoned" or "Duplicate" packages...');
    
    final pubspecFile = File(p.join(Directory.current.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      print('❌ pubspec.yaml not found.');
      return;
    }

    final content = pubspecFile.readAsStringSync();
    
    // Kirim konten pubspec ke AI untuk di-audit
    final prompt = '''
Analisis file pubspec.yaml Flutter berikut.
Berikan laporan intelijen tentang:
1. PACKAGE ABANDONED: Cari package yang sudah tidak diupdate lebih dari 1 tahun (berdasarkan pengetahuanmu).
2. DUPLICATE FUNCTIONALITY: Contoh jika ada dio dan http sekaligus, atau get dan provider sekaligus.
3. ALTERNATIF: Berikan saran package yang lebih aktif/modern jika ada.

Jawab dalam format Markdown yang rapi dan profesional (Global Standard).

PUBSPEC.YAML:
$content
''';

    try {
      final response = await http.post(
        Uri.parse('$ragBackendUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': prompt,
          'chat_history': [],
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('\n' + body['answer']);
        print('\n✅ Dependency audit complete.');
      } else {
        print('❌ AI Backend error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Failed to connect to AI Backend: $e');
    }
  }
}
