import 'dart:io';

class CicdManager {
  static Future<void> init(String provider) async {
    print('🚀 Generating CI/CD Pipeline for $provider...');
    
    if (provider.toLowerCase() == 'github') {
      final workflowDir = Directory('.github/workflows');
      if (!workflowDir.existsSync()) workflowDir.createSync(recursive: true);

      final workflowFile = File('.github/workflows/flutter_ci.yml');
      workflowFile.writeAsStringSync('''
name: Flutter CI

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
''');
      print('✅ Created .github/workflows/flutter_ci.yml');
    }
  }
}
