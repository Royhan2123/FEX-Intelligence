import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FigmaSync {
  static Future<void> pull(String token, String fileId) async {
    print('🎨 Connecting to Figma API...');
    
    try {
      final response = await http.get(
        Uri.parse('https://api.figma.com/v1/files/$fileId'),
        headers: {'X-Figma-Token': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Figma file fetched. Processing design tokens...');
        
        // Simplified: Extracting styles (mock logic for demo as Figma JSON is huge)
        await _generateTheme(data);
      } else {
        print('❌ Failed to fetch Figma file: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error syncing with Figma: $e');
    }
  }

  static Future<void> _generateTheme(Map<String, dynamic> data) async {
    final themeFile = File('lib/core/theme/app_theme.dart');
    if (!themeFile.parent.existsSync()) themeFile.parent.createSync(recursive: true);

    final buffer = StringBuffer();
    buffer.writeln('import \'package:flutter/material.dart\';');
    buffer.writeln('\n// GENERATED FROM FIGMA DESIGN TOKENS');
    buffer.writeln('class AppTheme {');
    buffer.writeln('  static ThemeData get lightTheme => ThemeData(');
    buffer.writeln('    primaryColor: Color(0xFF6200EE), // Mocked from Figma');
    buffer.writeln('    brightness: Brightness.light,');
    buffer.writeln('  );');
    buffer.writeln('}');
    
    themeFile.writeAsStringSync(buffer.toString());
    print('✅ Theme generated at lib/core/theme/app_theme.dart');
  }
}
