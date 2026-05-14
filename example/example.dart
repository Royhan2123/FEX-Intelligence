// ==========================================
// FEX Intelligence (Flutter Engine-X)
// Example Usage
// ==========================================
// 
// FEX is primarily a Command Line Interface (CLI) tool.
// To use it, you do not need to write Dart code. Instead, 
// you run it directly from your terminal.
//
// 1. Activate the CLI globally:
//    $ dart pub global activate fex_intelligence
//
// 2. Set up your Gemini AI API Key (Required for God-Level commands):
//    $ fex config --key YOUR_GEMINI_API_KEY
//
// 3. Generate a complete CRUD architecture:
//    $ fex generate crud -n User
//
// 4. Run the AI Security Pentester:
//    $ fex pentest
//
// 5. Simulate an AI Team Review on your current architecture:
//    $ fex review
//
// ==========================================
// Programmatic Usage (Advanced)
// ==========================================
import 'package:fex_intelligence/fex_intelligence.dart';

void main() async {
  print('Running FEX Programmatically...');
  
  // Example of using the AI Engine programmatically:
  // Note: Requires the API key to be set in ~/.fex/config.json
  try {
    final response = await AIEngine.ask(
      'What are the best practices for handling errors in Riverpod?'
    );
    print(response);
  } catch (e) {
    print('AI Engine Error: Make sure your API key is configured.');
  }
}
