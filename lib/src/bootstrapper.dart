import 'dart:io';

class ProjectBootstrapper {
  static Future<void> init(String projectName, String arch) async {
    print('🏗️ Bootstrapping $projectName with $arch Architecture...');
    
    final folders = [
      'lib/core/api',
      'lib/core/theme',
      'lib/core/utils',
      'lib/data/models',
      'lib/data/repositories',
      'lib/data/sources',
      'lib/features/home/presentation/pages', 
      'lib/features/home/presentation/widgets',
      'lib/features/home/domain/entities',
      'lib/features/home/domain/usecases',
    ];

    for (var folder in folders) {
      final dir = Directory(folder);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        print('✅ Created $folder');
      }
    }

    _createBaseFiles();
    print('🚀 Project $projectName is ready for development!');
  }

  static void _createBaseFiles() {
    final mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FEX App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(body: Center(child: Text('FEX Bootstrapped App'))),
    );
  }
}
''');
  }
}
