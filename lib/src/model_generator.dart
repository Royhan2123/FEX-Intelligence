import 'dart:io';
import 'package:path/path.dart' as p;

class ModelGenerator {
  static Future<void> generate(String className, Map<String, dynamic> json) async {
    print('📦 Generating Model: $className...');
    
    final buffer = StringBuffer();
    buffer.writeln('class $className {');
    
    // Fields
    json.forEach((key, value) {
      final type = _getDartType(value);
      buffer.writeln('  final $type $key;');
    });
    
    buffer.writeln('\n  $className({');
    json.keys.forEach((key) {
      buffer.writeln('    required this.$key,');
    });
    buffer.writeln('  });');

    // fromJson
    buffer.writeln('\n  factory $className.fromJson(Map<String, dynamic> json) {');
    buffer.writeln('    return $className(');
    json.forEach((key, value) {
      final type = _getDartType(value);
      buffer.writeln('      $key: json[\'$key\'] as $type,');
    });
    buffer.writeln('    );');
    buffer.writeln('  }');

    // toJson
    buffer.writeln('\n  Map<String, dynamic> toJson() {');
    buffer.writeln('    return {');
    json.keys.forEach((key) {
      buffer.writeln('      \'$key\': $key,');
    });
    buffer.writeln('    };');
    buffer.writeln('  }');

    buffer.writeln('}');

    final file = File('lib/core/models/${className.toLowerCase()}.dart');
    if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
    
    file.writeAsStringSync(buffer.toString());
    print('✅ Model generated at: ${file.path}');
  }

  static String _getDartType(dynamic value) {
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) return 'List';
    return 'dynamic';
  }
}
