import 'ai_engine.dart';

class TeamSimulation {
  static Future<void> run() async {
    print('👥 Starting AI Team Simulation (Product Manager, Senior Dev, QA)...');
    
    final prompt = 'Simulasikan diskusi antara PM, Senior Dev, dan QA untuk fitur "Real-time Notification" di Flutter. Berikan kesimpulan arsitektur terbaik.';
    
    try {
      final answer = await AIEngine.ask(prompt);
      print('\n💬 TEAM DISCUSSION SUMMARY:\n$answer');
    } catch (e) {
      print('❌ Simulation failed: $e');
    }
  }
}
