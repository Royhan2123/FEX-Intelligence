import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// =============================================
//  EvolveEngine - The Architecture Migrator
// =============================================
class EvolveEngine {
  final String ragBackendUrl;

  EvolveEngine({required this.ragBackendUrl});

  // Metode statis untuk menjalankan evolusi dari CLI
  static Future<void> run(String from, String to, {String backendUrl = 'http://localhost:8000'}) async {
    final engine = EvolveEngine(ragBackendUrl: backendUrl);
    await engine.evolveProject(from, to);
  }

  Future<void> evolveProject(String from, String to) async {
    print('🧬 Starting Architecture Evolution: $from ➔ $to...');
    
    final libDir = Directory(p.join(Directory.current.path, 'lib'));
    if (!libDir.existsSync()) {
      print('❌ lib/ folder not found. Pastikan kamu menjalankan ini di root project Flutter.');
      return;
    }

    // Scan file yang butuh evolusi (GetX -> Riverpod)
    List<File> filesToEvolve = [];
    await for (final f in libDir.list(recursive: true)) {
      if (f is File && f.path.endsWith('.dart')) {
        final content = f.readAsStringSync();
        // Deteksi GetX (Target utama kita)
        if (content.contains('GetxController') || 
            content.contains('Get.find') || 
            content.contains('GetView') || 
            content.contains('.obs')) {
          filesToEvolve.add(f);
        }
      }
    }

    if (filesToEvolve.isEmpty) {
      print('ℹ️ No files found matching source architecture ($from).');
      return;
    }

    print('🔍 Found ${filesToEvolve.length} files to evolve. Processing with AI...');

    for (final file in filesToEvolve) {
      final fileName = p.basename(file.path);
      stdout.write('🧬 Evolving $fileName... ');
      await _evolveFile(file, from, to);
      print('DONE ✅');
    }

    print('\n✨ Evolution complete! ✨');
    print('💡 REKOMENDASI:');
    print('1. Tambahkan dependency "$to" di pubspec.yaml kamu.');
    print('2. Jalankan "flutter pub get".');
    print('3. Cek file yang sudah di-evolusi untuk memastikan logika bisnis tetap terjaga.');
  }

  Future<void> _evolveFile(File file, String from, String to) async {
    try {
      final code = file.readAsStringSync();
      
      final prompt = '''
Kamu adalah senior Flutter Architect. Tugasmu adalah mengubah arsitektur kode berikut:
DARI: $from (GetX)
KE: $to (Riverpod)

ATURAN KONVERSI:
1. GetxController -> AsyncNotifier atau StateNotifier.
2. RxInt, RxString, .obs -> Gunakan StateProvider atau StateNotifier.
3. Get.find() -> ref.watch() atau ref.read().
4. GetView -> ConsumerWidget.
5. Obx() atau GetX() -> Consumer atau ref.watch.
6. Update semua import yang relevan.

Berikan HANYA kode lengkap yang sudah di-refactor, tanpa penjelasan tambahan.

KODE ASLI:
$code
''';

      final res = await http.post(
        Uri.parse('$ragBackendUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': prompt,
          'chat_history': [],
        }),
      ).timeout(const Duration(seconds: 60));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        var evolvedCode = body['answer'] as String;
        
        // Bersihkan kode dari markdown
        evolvedCode = _extractCode(evolvedCode);

        // Timpa file asli dengan kode baru
        file.writeAsStringSync(evolvedCode);
      }
    } catch (e) {
      print('\n⚠️ Failed to evolve ${p.basename(file.path)}: $e');
    }
  }

  String _extractCode(String text) {
    if (text.contains('```dart')) {
      final parts = text.split('```dart');
      if (parts.length > 1) {
        return parts[1].split('```')[0].trim();
      }
    } else if (text.contains('```')) {
      final parts = text.split('```');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    return text.trim();
  }
}