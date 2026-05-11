import 'dart:io';
import 'package:path/path.dart' as p;

class CrudGenerator {
  static Future<void> generate(String name, Map<String, dynamic> jsonData, String stateType) async {
    print('⚡ Generating Zero-Code CRUD ($stateType) for: $name...');

    final className = name[0].toUpperCase() + name.substring(1);
    final fileName = name.toLowerCase();
    final libPath = p.join(Directory.current.path, 'lib');

    // Folder structure logic based on state type
    _createFolders(libPath, fileName, stateType);

    // 1. Generate Model (Always the same)
    _generateModel(libPath, className, jsonData);

    // 2. Generate Logic based on State Management
    switch (stateType.toLowerCase()) {
      case 'bloc':
      case 'cubit':
        _generateBlocLogic(libPath, className, fileName, stateType == 'cubit');
        break;
      case 'riverpod':
        _generateRiverpodLogic(libPath, className, fileName);
        break;
      case 'provider':
        _generateProviderLogic(libPath, className, fileName);
        break;
      default: // Default to Riverpod if no specific state type is provided or recognized
        _generateRiverpodLogic(libPath, className, fileName);
    }

    print('\n✅ $stateType CRUD for $className generated successfully!');
  }

  static void _createFolders(String libPath, String fileName, String state) {
    final base = p.join(libPath, 'app', 'modules', fileName);
    Directory(p.join(libPath, 'app', 'data', 'models')).createSync(recursive: true);
    Directory(p.join(base, 'controllers')).createSync(recursive: true); // Keep for general structure, might be renamed for Riverpod
    Directory(p.join(base, 'views')).createSync(recursive: true);
    
    if (state == 'bloc' || state == 'cubit') {
      Directory(p.join(base, state)).createSync(recursive: true);
    }
  }

  static void _generateModel(String libPath, String className, Map<String, dynamic> json) {
    final buffer = StringBuffer();
    buffer.writeln('class ${className}Model {\n  final Map<String, dynamic> data;\n  ${className}Model(this.data);\n}');
    File(p.join(libPath, 'app', 'data', 'models', '${className.toLowerCase()}_model.dart'))
        .writeAsStringSync(buffer.toString());
  }

  // --- BLOC / CUBIT LOGIC ---
  static void _generateBlocLogic(String libPath, String className, String fileName, bool isCubit) {
    final path = p.join(libPath, 'app', 'modules', fileName, isCubit ? 'cubit' : 'bloc');
    if (isCubit) {
      File(p.join(path, '${fileName}_cubit.dart')).writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
class ${className}Cubit extends Cubit<List> {
  ${className}Cubit() : super([]);
  void load() => emit([]);
}
''');
    } else {
      File(p.join(path, '${fileName}_bloc.dart')).writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
// Bloc Implementation...
''');
    }
  }

  // --- RIVERPOD LOGIC ---
  static void _generateRiverpodLogic(String libPath, String className, String fileName) {
    // For Riverpod, we'll create a provider file.
    // The 'controllers' folder might be renamed or used differently in a pure Riverpod setup.
    // For simplicity, we'll place the provider directly in the module folder.
    final path = p.join(libPath, 'app', 'modules', fileName);
    File(p.join(path, '${fileName}_provider.dart')).writeAsStringSync('''
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Example: A simple StateProvider for a list of items
final ${fileName}ListProvider = StateProvider<List<dynamic>>((ref) => []);

// Example: An AsyncNotifier for more complex state management with async operations
class ${className}Notifier extends AsyncNotifier<List<dynamic>> {
  @override
  Future<List<dynamic>> build() async {
    // Simulate fetching initial data
    await Future.delayed(const Duration(milliseconds: 300));
    return []; // Initial empty list
  }

  void addItem(dynamic item) {
    state = AsyncValue.data([...state.value!, item]);
  }

  Future<void> loadItems() async {
    state = const AsyncValue.loading();
    try {
      // Simulate an async operation to load items
      await Future.delayed(const Duration(seconds: 1));
      final newItems = ['Item 1', 'Item 2', 'Item 3']; // Example data
      state = AsyncValue.data(newItems);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final ${fileName}NotifierProvider = AsyncNotifierProvider<${className}Notifier, List<dynamic>>(() {
  return ${className}Notifier();
});
''');
  }

  // --- PROVIDER LOGIC ---
  static void _generateProviderLogic(String libPath, String className, String fileName) {
     File(p.join(libPath, 'app', 'modules', fileName, 'provider.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';
class ${className}Provider extends ChangeNotifier {
  List items = [];
  bool isLoading = false;

  void load() { 
    isLoading = true;
    notifyListeners();
    // Simulate data loading
    Future.delayed(const Duration(seconds: 1), () {
      items = ['Item A', 'Item B']; // Example data
      isLoading = false;
      notifyListeners();
    });
  }

  void addItem(dynamic item) {
    items.add(item);
    notifyListeners();
  }
}
''');
  }
}