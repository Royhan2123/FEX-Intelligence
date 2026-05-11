import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class CodeHealer {
  final String ragBackendUrl;

  CodeHealer({this.ragBackendUrl = 'http://localhost:8000'});

  static Future<void> run(String filePath, {String backendUrl = 'http://localhost:8000'}) async {
    final healer = CodeHealer(ragBackendUrl: backendUrl);
    await healer._healFile(filePath);
  }

  Future<void> _healFile(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      print('❌ File tidak ditemukan: $filePath');
      return;
    }

    print('🩹 Attempting to heal: ${p.basename(filePath)}...');
    print('🧠 Sending to AI for surgery...');

    try {
      final originalCode = file.readAsStringSync();
      
      final prompt = '''
Kamu adalah senior Flutter developer. Tugasmu adalah memperbaiki (HEAL) kode berikut.
Fokus pada:
1. Tambahkan try-catch pada setiap network call/async operation.
2. Perbaiki penamaan file/variabel agar sesuai standar Flutter (snake_case untuk file, camelCase untuk variabel).
3. Pastikan semua controller memiliki method dispose()/onClose().
4. Perbaiki bug potensial lainnya.

Berikan HANYA kode lengkap yang sudah diperbaiki, tanpa penjelasan apapun sebelum atau sesudah kode.

KODE ASLI:
$originalCode
''';

      final response = await http.post(
        Uri.parse('$ragBackendUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': prompt,
          'chat_history': [],
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        var fixedCode = body['answer'] as String;

        // Clean up markdown code blocks if present
        fixedCode = _extractCode(fixedCode);

        // Overwrite the file
        file.writeAsStringSync(fixedCode);
        
        print('✅ File ${p.basename(filePath)} successfully HEALED!');
        print('📝 Changes applied. Silakan periksa kodenya.');
      } else {
        print('❌ AI Backend error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Gagal melakukan healing: $e');
    }
  }

  String _extractCode(String text) {
    if (text.contains('```dart')) {
      final start = text.indexOf('```dart') + 7;
      final end = text.lastIndexOf('```');
      return text.substring(start, end).trim();
    } else if (text.contains('```')) {
      final start = text.indexOf('```') + 3;
      final end = text.lastIndexOf('```');
      return text.substring(start, end).trim();
    }
    return text.trim();
  }
}
