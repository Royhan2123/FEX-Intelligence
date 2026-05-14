import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path/path.dart' as p;

/// The core AI engine for FEX Intelligence.
/// 
/// This class handles communication with Google's Gemini API and manages
/// the storage of API keys.
class AIEngine {
  static String? _apiKey;

  /// Internal method to retrieve the API key from environment variables or local config.
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

  /// Sends a [prompt] to the Gemini AI model and returns the response string.
  /// 
  /// Throws an exception if the API key is not configured.
  static Future<String> ask(String prompt) async {
    final apiKey = await _getApiKey();
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    
    return response.text ?? 'No response from AI.';
  }

  /// Securely saves the Gemini API [key] to the local configuration file.
  static Future<void> saveKey(String key) async {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    final configDir = Directory(p.join(home, '.fex'));
    if (!configDir.existsSync()) configDir.createSync();
    
    final configFile = File(p.join(configDir.path, '.fex_config'));
    await configFile.writeAsString(key);
    print('✅ API Key saved to ${configFile.path}');
  }
}
