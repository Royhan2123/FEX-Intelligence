import 'dart:io';
import 'package:path/path.dart' as p;

class RagClientGenerator {
  static Future<void> generate(String baseUrl) async {
    print('🚀 Generating RAG Client & AI Chat UI...');

    final libPath = p.join(Directory.current.path, 'lib');
    if (!Directory(libPath).existsSync()) {
      print('❌ Error: Folder lib tidak ditemukan. Pastikan kamu berada di root project Flutter.');
      return;
    }

    final aiDataPath = p.join(libPath, 'app', 'data', 'services');
    final aiUiPath = p.join(libPath, 'app', 'modules', 'ai_chat');
    
    Directory(aiDataPath).createSync(recursive: true);
    Directory(aiUiPath).createSync(recursive: true);

    _generateService(aiDataPath, baseUrl);
    _generateController(aiUiPath);
    _generateView(aiUiPath);

    print('\n✅ AI RAG Feature generated successfully!');
    print('💡 Next steps:');
    print('   - Tambahkan package http: `flutter pub add http`');
  }

  static void _generateService(String path, String baseUrl) {
    final file = File(p.join(path, 'ai_service.dart'));
    file.writeAsStringSync('''
import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  final String baseUrl = '$baseUrl';

  Future<Map<String, dynamic>> query(String question) async {
    try {
      final response = await http.post(
        Uri.parse('\$baseUrl/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question, 'top_k': 5}),
      );
      return response.statusCode == 200 ? jsonDecode(response.body) : throw Exception('Error API');
    } catch (e) { rethrow; }
  }

  Future<Map<String, dynamic>> chat(String question, List<Map<String, dynamic>> history) async {
    try {
      final response = await http.post(
        Uri.parse('\$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question, 'chat_history': history}),
      );
      return response.statusCode == 200 ? jsonDecode(response.body) : throw Exception('Error API');
    } catch (e) { rethrow; }
  }
}
''');
  }

  static void _generateController(String path) {
    final file = File(p.join(path, 'ai_chat_controller.dart'));
    file.writeAsStringSync('''
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/services/ai_service.dart';

class AiChatController extends GetxController {
  final AiService _aiService = AiService();
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    textController.clear();
    messages.add({'role': 'user', 'content': text});
    isLoading.value = true;
    try {
      final response = await _aiService.chat(text, messages.toList());
      messages.add({'role': 'assistant', 'content': response['answer'], 'sources': response['sources'] ?? []});
    } catch (e) { Get.snackbar('Error', 'Gagal: \$e'); }
    finally { isLoading.value = false; }
  }
}
''');
  }

  static void _generateView(String path) {
    final file = File(p.join(path, 'ai_chat_view.dart'));
    file.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ai_chat_controller.dart';

class AiChatPage extends GetView<AiChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Assistant (RAG)')),
      body: Column(
        children: [
          Expanded(child: Obx(() => ListView.builder(
            itemCount: controller.messages.length,
            itemBuilder: (context, index) {
              final msg = controller.messages[index];
              return ListTile(
                title: Text(msg['role'].toUpperCase()),
                subtitle: Text(msg['content']),
              );
            },
          ))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller.textController)),
                IconButton(icon: Icon(Icons.send), onPressed: controller.sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
''');
  }
}
