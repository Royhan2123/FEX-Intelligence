import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path/path.dart' as p;

class AIEngine {
  static String? _apiKey;

  // Mendapatkan API Key dari Environment atau Config file
  static Future<String> _getApiKey() async {
    if (_apiKey != null) return _apiKey!;

    // 1. Cek dari Environment Variable
    final envKey = Platform.environment['GEMINI_API_KEY'];
    if (envKey != null) return envKey;

    // 2. C check from home directory config
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    final configFile = File(p.join(home, '.fex', '.fex_config'));
    if (configFile.existsSync()) {
      return configFile.readAsStringSync().trim();
    }

    throw Exception('⚠️ GEMINI_API_KEY not found! Run "fex config --key YOUR_KEY" first.');
  }

  static Future<String> ask(String prompt) async {
    final apiKey = await _getApiKey();
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    
    return response.text ?? 'No response from AI.';
  }

  static Future<void> saveKey(String key) async {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    final configDir = Directory(p.join(home, '.fex'));
    if (!configDir.existsSync()) configDir.createSync();
    
    final configFile = File(p.join(configDir.path, '.fex_config'));
    await configFile.writeAsString(key);
    print('✅ API Key saved to ${configFile.path}');
  }
}
