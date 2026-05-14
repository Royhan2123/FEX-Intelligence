import 'dart:io';

class WidgetGenerator {
  static Future<void> create(String name, String type) async {
    print('🏗️ Creating $type widget: $name...');
    
    final fileName = _toSnakeCase(name);
    final file = File('lib/presentation/widgets/$fileName.dart');
    if (!file.parent.existsSync()) file.parent.createSync(recursive: true);

    final buffer = StringBuffer();
    buffer.writeln('import \'package:flutter/material.dart\';');
    buffer.writeln('');

    if (type == 'stateful') {
      buffer.writeln('''
class $name extends StatefulWidget {
  const $name({super.key});

  @override
  State<$name> createState() => _${name}State();
}

class _${name}State extends State<$name> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
''');
    } else {
      buffer.writeln('''
class $name extends StatelessWidget {
  const $name({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
''');
    }

    file.writeAsStringSync(buffer.toString());
    print('✅ Widget created at: ${file.path}');
  }

  static String _toSnakeCase(String name) {
    return name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => '_${match.group(1)!.toLowerCase()}').substring(1);
  }
}
