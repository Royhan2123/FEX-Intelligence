import 'dart:io';

/// Handles the initialization and bootstrapping of new Flutter projects.
class ProjectBootstrapper {
  /// Initializes a new project with the given [projectName] and [arch] style.
  /// 
  /// If a project doesn't exist in the current directory, it runs `flutter create`.
  /// Then it scaffolds the FEX-specific directory structure and base files.
  static Future<void> init(String projectName, String arch) async {
    print('🏗️ Bootstrapping $projectName with $arch Architecture...');
    
    // 1. Check if pubspec exists, if not run flutter create
    final pubspec = File('pubspec.yaml');
    if (!pubspec.existsSync()) {
      print('📦 No project detected. Running "flutter create ." ...');
      final result = Process.runSync('flutter', ['create', '--project-name', projectName.toLowerCase(), '.']);
      if (result.exitCode != 0) {
        print('❌ Flutter create failed: ${result.stderr}');
        return;
      }
      print('✅ Flutter base project created.');
    }

    // 2. Define FEX Clean Architecture folders
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

    // 3. Create folders
    for (var folder in folders) {
      final dir = Directory(folder);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        print('✅ Created $folder');
      }
    }

    // 4. Overwrite main.dart with FEX boilerplate
    _createBaseFiles();
    
    print('\n🚀 Project $projectName is ready for development!');
    print('💡 Next step: Run "fex config --key YOUR_GEMINI_KEY" to enable AI features.');
  }

  /// Creates the base main.dart file with FEX-specific boilerplate.
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
      title: 'FEX Intelligence App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FexHome(),
    );
  }
}

class FexHome extends StatelessWidget {
  const FexHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FEX Intelligence'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text(
              'FEX Bootstrapped App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clean Architecture & AI Ready',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.rocket_launch),
              label: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
''');
  }
}
