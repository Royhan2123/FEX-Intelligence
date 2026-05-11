import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// =============================================
//  Autonomous QA Agent
//  Uses Gemini API to simulate a real QA engineer
// =============================================
class QaAgent {
  final String ragBackendUrl;
  final List<Map<String, dynamic>> _findings = [];
  int _filesAnalyzed = 0;

  QaAgent({this.ragBackendUrl = 'http://localhost:8000'});

  static Future<void> run({String backendUrl = 'http://localhost:8000'}) async {
    final agent = QaAgent(ragBackendUrl: backendUrl);
    await agent._startAnalysis();
  }

  Future<void> _startAnalysis() async {
    _printBanner();

    // 1. First, check if RAG backend is alive
    final isBackendAlive = await _checkBackend();
    if (!isBackendAlive) {
      print('❌ RAG Backend tidak aktif di $ragBackendUrl');
      print('   Jalankan dulu: python main.py di folder rag-backend');
      print('   Lanjut dengan static analysis saja...\n');
    }

    final libDir = Directory(p.join(Directory.current.path, 'lib'));
    if (!libDir.existsSync()) {
      print('❌ lib/ folder not found.');
      return;
    }

    // 2. Static Analysis Phase
    print('📋 Phase 1: Static Analysis...');
    await _runStaticAnalysis(libDir);

    // 3. AI-Powered Analysis Phase
    if (isBackendAlive) {
      print('\n🧠 Phase 2: AI-Powered Deep Analysis...');
      await _runAiAnalysis(libDir);
    }

    // 4. Generate Report
    _generateReport();
  }

  // =============================================
  //  PHASE 1: Static Analysis
  // =============================================
  Future<void> _runStaticAnalysis(Directory libDir) async {
    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        _filesAnalyzed++;
        final content = entity.readAsStringSync();
        final lines = content.split('\n');
        final fileName = entity.path.replaceAll(Directory.current.path, '');

        _checkMissingAsyncAwait(content, lines, fileName);
        _checkMissingNullCheck(content, lines, fileName);
        _checkUnhandledException(content, lines, fileName);
        _checkMissingDispose(content, lines, fileName);
        _checkEmptyCatchBlock(content, lines, fileName);
        _checkInfiniteLoop(content, lines, fileName);
        _checkHardcodedStrings(content, lines, fileName);
      }
    }
    print('   ✅ Static analysis selesai — ${_findings.length} issues ditemukan');
  }

  void _checkMissingAsyncAwait(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      // Function that returns Future but called without await
      if (lines[i].contains('Future') && lines[i].contains('()') &&
          !lines[i].contains('await') && !lines[i].contains('async') &&
          !lines[i].contains('//')) {
        _addFinding('MISSING_AWAIT', 'medium', file, i + 1,
            'Kemungkinan Future tidak di-await. Bisa menyebabkan race condition.',
            lines[i].trim());
      }
    }
  }

  void _checkMissingNullCheck(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      // Using ! operator excessively (force unwrap)
      final forceUnwraps = RegExp(r'\w+!\.').allMatches(lines[i]).length;
      if (forceUnwraps > 2) {
        _addFinding('EXCESSIVE_FORCE_UNWRAP', 'high', file, i + 1,
            'Terlalu banyak null force-unwrap (!) pada satu baris. Potensi null crash.',
            lines[i].trim());
      }
    }
  }

  void _checkUnhandledException(String content, List<String> lines, String file) {
    bool inTryCatch = false;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('try {')) inTryCatch = true;
      if (lines[i].contains('} catch')) inTryCatch = false;

      // Async function without try-catch that does network call
      if (!inTryCatch && lines[i].contains('await http.') || 
          (!inTryCatch && lines[i].contains('await dio.'))) {
        _addFinding('UNHANDLED_NETWORK_EXCEPTION', 'high', file, i + 1,
            'Network call tanpa try-catch. App bisa crash jika terjadi error koneksi.',
            lines[i].trim());
      }
    }
  }

  void _checkMissingDispose(String content, List<String> lines, String file) {
    final hasController = content.contains('TextEditingController') ||
        content.contains('ScrollController') ||
        content.contains('AnimationController');
    final hasDispose = content.contains('dispose()') || content.contains('onClose()');

    if (hasController && !hasDispose) {
      _addFinding('MISSING_DISPOSE', 'high', file, null,
          'Controller ditemukan tapi tidak ada dispose/onClose. Menyebabkan memory leak.',
          null);
    }
  }

  void _checkEmptyCatchBlock(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim() == '} catch (e) {' || lines[i].trim() == 'catch (e) {') {
        if (i + 1 < lines.length && (lines[i + 1].trim() == '}' || lines[i + 1].trim().isEmpty)) {
          _addFinding('EMPTY_CATCH_BLOCK', 'medium', file, i + 1,
              'Empty catch block! Error diabaikan begitu saja. Minimal tambahkan log.',
              lines[i].trim());
        }
      }
    }
  }

  void _checkInfiniteLoop(String content, List<String> lines, String file) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('while (true)') || lines[i].contains('for (;;)')) {
        _addFinding('POTENTIAL_INFINITE_LOOP', 'medium', file, i + 1,
            'Loop tak terbatas ditemukan. Pastikan ada kondisi break/exit.',
            lines[i].trim());
      }
    }
  }

  void _checkHardcodedStrings(String content, List<String> lines, String file) {
    int hardcodedCount = 0;
    for (final line in lines) {
      // Count string literals in UI (Text widgets)
      if (line.contains('Text(\'') || line.contains('Text("')) hardcodedCount++;
    }
    if (hardcodedCount > 15) {
      _addFinding('HARDCODED_STRINGS', 'low', file, null,
          '$hardcodedCount string hardcoded ditemukan. Pertimbangkan internasionalisasi (i18n/l10n).',
          null);
    }
  }

  // =============================================
  //  PHASE 2: AI-Powered Analysis via RAG Backend
  // =============================================
  Future<void> _runAiAnalysis(Directory libDir) async {
    // Pick the most complex files for AI review (top 3 by line count)
    final dartFiles = <File>[];
    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart') &&
          (entity.path.contains('controller') || entity.path.contains('repository'))) {
        dartFiles.add(entity);
      }
    }

    // Sort by file size (larger = more complex)
    dartFiles.sort((a, b) => b.lengthSync().compareTo(a.lengthSync()));
    final filesToAnalyze = dartFiles.take(3).toList();

    for (final file in filesToAnalyze) {
      final fileName = p.basename(file.path);
      print('   🔍 AI analyzing: $fileName...');
      await _aiAnalyzeFile(file);
    }
  }

  Future<void> _aiAnalyzeFile(File file) async {
    try {
      final content = file.readAsStringSync();
      final truncated = content.length > 3000 ? content.substring(0, 3000) + '\n...' : content;
      final fileName = p.basename(file.path);

      final prompt = '''
Kamu adalah senior QA engineer yang berpengalaman dalam Flutter dan Dart.
Analisis kode berikut dan temukan potensi bug, anti-pattern, atau masalah kualitas.
Berikan jawaban HANYA dalam format JSON array, tanpa penjelasan tambahan.

Format:
[
  {"severity": "high/medium/low", "issue": "nama issue", "description": "penjelasan singkat"}
]

Kode dari file "$fileName":
$truncated
''';

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
        final answer = body['answer'] as String;

        // Try to parse JSON from AI response
        try {
          final jsonStart = answer.indexOf('[');
          final jsonEnd = answer.lastIndexOf(']') + 1;
          if (jsonStart >= 0 && jsonEnd > jsonStart) {
            final jsonStr = answer.substring(jsonStart, jsonEnd);
            final aiFindings = jsonDecode(jsonStr) as List;
            for (final finding in aiFindings) {
              _addFinding(
                'AI_${finding['issue'].toString().toUpperCase().replaceAll(' ', '_')}',
                finding['severity'] ?? 'medium',
                file.path.replaceAll(Directory.current.path, ''),
                null,
                '[AI Review] ${finding['description']}',
                null,
              );
            }
          }
        } catch (_) {
          // AI response wasn't valid JSON, add as single finding
          _addFinding('AI_REVIEW', 'info',
              file.path.replaceAll(Directory.current.path, ''), null,
              '[AI] ${answer.substring(0, answer.length.clamp(0, 200))}', null);
        }
      }
    } catch (e) {
      print('   ⚠️ AI analysis skipped for ${p.basename(file.path)}: $e');
    }
  }

  // =============================================
  //  HELPERS
  // =============================================
  Future<bool> _checkBackend() async {
    try {
      final res = await http.get(Uri.parse('$ragBackendUrl/health'))
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void _addFinding(String type, String severity, String file, int? line,
      String description, String? snippet) {
    _findings.add({
      'type': type,
      'severity': severity,
      'file': file,
      'line': line,
      'description': description,
      'snippet': snippet,
    });
  }

  // =============================================
  //  REPORT GENERATION
  // =============================================
  void _generateReport() {
    final critical = _findings.where((f) => f['severity'] == 'critical').toList();
    final high = _findings.where((f) => f['severity'] == 'high').toList();
    final medium = _findings.where((f) => f['severity'] == 'medium').toList();
    final low = _findings.where((f) => f['severity'] == 'low').toList();
    final info = _findings.where((f) => f['severity'] == 'info').toList();

    print('');
    print('╔══════════════════════════════════════════════════╗');
    print('║           🤖 QA AGENT REPORT                     ║');
    print('╚══════════════════════════════════════════════════╝');
    print('');

    void printGroup(String label, List items) {
      if (items.isEmpty) return;
      print('$label (${items.length})');
      print('─' * 52);
      for (final f in items) {
        print('  [${f['type']}]');
        print('  📄 ${f['file']}${f['line'] != null ? ':${f['line']}' : ''}');
        print('  💬 ${f['description']}');
        if (f['snippet'] != null) {
          final s = f['snippet'].toString();
          print('  🔍 ${s.substring(0, s.length.clamp(0, 80))}');
        }
        print('');
      }
    }

    printGroup('🚨 CRITICAL', critical);
    printGroup('🔴 HIGH', high);
    printGroup('🟡 MEDIUM', medium);
    printGroup('🟢 LOW', low);
    printGroup('ℹ️  INFO (AI)', info);

    print('═' * 52);
    print('  📊 Files analyzed   : $_filesAnalyzed');
    print('  🔴 High             : ${high.length}');
    print('  🟡 Medium           : ${medium.length}');
    print('  🟢 Low              : ${low.length}');
    print('  ℹ️  AI findings      : ${info.length}');
    print('  📋 Total issues     : ${_findings.length}');
    print('═' * 52);

    // Save report
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').substring(0, 19);
    final reportFile = File('qa_report_$timestamp.md');
    final buffer = StringBuffer();
    buffer.writeln('# 🤖 QA Agent Report\nGenerated: ${DateTime.now()}\n');
    buffer.writeln('## Summary\n| Severity | Count |\n|---|---|');
    buffer.writeln('| High | ${high.length} |\n| Medium | ${medium.length} |');
    buffer.writeln('| Low | ${low.length} |\n| **Total** | **${_findings.length}** |');
    for (final f in _findings) {
      buffer.writeln('\n---\n**[${(f['severity'] as String).toUpperCase()}] ${f['type']}**');
      buffer.writeln('- File: `${f['file']}${f['line'] != null ? ':${f['line']}' : ''}`');
      buffer.writeln('- ${f['description']}');
    }
    reportFile.writeAsStringSync(buffer.toString());
    print('\n📝 Report saved: ${reportFile.path}');
  }

  void _printBanner() {
    print('');
    print('╔══════════════════════════════════════════════════╗');
    print('║   🤖 AUTONOMOUS QA AGENT                         ║');
    print('║   Powered by flutter_cli_generate + Gemini AI    ║');
    print('╚══════════════════════════════════════════════════╝');
    print('');
    print('📂 Target: ${Directory.current.path}');
    print('🧠 AI Backend: $ragBackendUrl');
    print('');
  }
}
