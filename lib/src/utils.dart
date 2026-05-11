import 'dart:io';
import 'package:path/path.dart' as p;

String toPascalCase(String text) => text[0].toUpperCase() + text.substring(1);

void saveFile(String folder, String filename, String content) {
  final dir = Directory(folder);
  if (!dir.existsSync()) dir.createSync(recursive: true);
  File(p.join(dir.path, filename)).writeAsStringSync(content);
  print('Generated: $folder/$filename');
}

String mapSimpleType(String t) {
  switch (t) {
    case 'int': return 'int';
    case 'double': return 'double';
    case 'bool': return 'bool';
    case 'list': return 'List<dynamic>';
    default: return 'String';
  }
}
