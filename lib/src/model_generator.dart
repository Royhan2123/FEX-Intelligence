import 'dart:io';

class ModelGenerator {
  static Future<void> generate(String className, Map<String, dynamic> json) async {
    print('📦 Generating Recursive Model: $className...');
    
    final buffer = StringBuffer();
    final nestedModels = <String, Map<String, dynamic>>{};

    buffer.writeln('class $className {');
    
    // Fields
    json.forEach((key, value) {
      final type = _getDartType(key, value, nestedModels);
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
      final type = _getDartType(key, value, nestedModels);
      if (value is Map) {
        final subClassName = _toClassName(key);
        buffer.writeln('      $key: $subClassName.fromJson(json[\'$key\'] as Map<String, dynamic>),');
      } else if (value is List && value.isNotEmpty && value.first is Map) {
        final subClassName = _toClassName(key);
        buffer.writeln('      $key: (json[\'$key\'] as List).map((i) => $subClassName.fromJson(i as Map<String, dynamic>)).toList(),');
      } else {
        buffer.writeln('      $key: json[\'$key\'] as $type,');
      }
    });
    buffer.writeln('    );');
    buffer.writeln('  }');

    buffer.writeln('}');

    // Process Nested Models
    for (var entry in nestedModels.entries) {
      final subCode = await _generateSubModel(entry.key, entry.value);
      buffer.writeln('\n$subCode');
    }

    final file = File('lib/core/models/${className.toLowerCase()}.dart');
    if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
    
    file.writeAsStringSync(buffer.toString());
    print('✅ Model generated with nested support at: ${file.path}');
  }

  static String _getDartType(String key, dynamic value, Map<String, Map<String, dynamic>> nestedModels) {
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is Map) {
      final subName = _toClassName(key);
      nestedModels[subName] = value.cast<String, dynamic>();
      return subName;
    }
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      if (value.first is String) return 'List<String>';
      if (value.first is int) return 'List<int>';
      if (value.first is Map) {
        final subName = _toClassName(key);
        nestedModels[subName] = value.first.cast<String, dynamic>();
        return 'List<$subName>';
      }
      return 'List<dynamic>';
    }
    return 'dynamic';
  }

  static String _toClassName(String key) {
    return key[0].toUpperCase() + key.substring(1).replaceAll('_', '');
  }

  static Future<String> _generateSubModel(String className, Map<String, dynamic> json) async {
    final buffer = StringBuffer();
    buffer.writeln('class $className {');
    json.forEach((key, value) {
      // Simple non-recursive for sub-models to avoid infinite loops in this simple implementation
      final type = (value is Map) ? 'Map<String, dynamic>' : (value is List ? 'List' : 'dynamic');
      final finalType = (type == 'dynamic') ? _getDartType(key, value, {}) : type;
      buffer.writeln('  final $finalType $key;');
    });
    buffer.writeln('\n  $className({');
    json.keys.forEach((key) => buffer.writeln('    required this.$key,'));
    buffer.writeln('  });\n');
    buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) => $className(');
    json.forEach((key, value) => buffer.writeln('    $key: json[\'$key\'],'));
    buffer.writeln('  );\n}');
    return buffer.toString();
  }
}
