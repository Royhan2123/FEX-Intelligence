import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import '../lib/src/architecture_auditor.dart';
import '../lib/src/component_generator.dart';
import '../lib/src/crud_generator.dart';
import '../lib/src/mock_server_generator.dart';
import '../lib/src/rag_client_generator.dart';
import '../lib/src/security_scanner.dart'; // Z3
import '../lib/src/qa_agent.dart';        // Z5
import '../lib/src/code_healer.dart';    // HEAL
import '../lib/src/deps_doctor.dart';    // DEPS
import '../lib/src/test_generator.dart'; // TEST
import '../lib/src/global_modules.dart'; // GLOBAL MODULES
import '../lib/src/next_level_modules.dart'; // GOD LEVEL MODULES
import '../lib/src/evolve_engine.dart';      // EVOLVE ENGINE
import '../lib/src/performance_surgeon.dart'; // PERFORMANCE & MONITOR
import '../lib/src/log_injector.dart';      // LOG INJECTOR

void main(List<String> arguments) async {
  final parser = ArgParser();

  // --- COMMAND: DEBUGGING & LOGGING ---
  parser.addCommand('log');

  // --- COMMAND: END-GAME PERFORMANCE ---
  parser.addCommand('monitor');
  parser.addCommand('optimize');

  // --- COMMAND: EVOLVE (ARCHITECTURE EVOLUTION) ---
  final evolveCommand = parser.addCommand('evolve');
  evolveCommand.addOption('from', help: 'Source architecture', defaultsTo: 'getx');
  evolveCommand.addOption('to', help: 'Target architecture', defaultsTo: 'riverpod');

  // --- COMMAND: GOD LEVEL INTELLIGENCE ---
  parser.addCommand('review');
  parser.addCommand('compliance');
  final refactorCommand = parser.addCommand('refactor');
  refactorCommand.addOption('file', abbr: 'f', help: 'File to refactor');

  // --- COMMAND: GLOBAL INTELLIGENCE ---
  parser.addCommand('changelog');
  parser.addCommand('size');
  parser.addCommand('a11y');
  parser.addCommand('migrate');
  parser.addCommand('localize');
  parser.addCommand('perf');
  parser.addCommand('doctor');

  // --- COMMAND: TEST (AI TEST GENERATOR) ---
  final testCommand = parser.addCommand('test');
  testCommand.addOption('file', abbr: 'f', help: 'File to generate tests for');

  // --- COMMAND: AUDIT & MOCK ---
  parser.addCommand('audit');
  parser.addCommand('mock');
  
  // --- COMMAND: HEAL ---
  final healCommand = parser.addCommand('heal');
  healCommand.addOption('file', abbr: 'f', help: 'File path to heal');
  
  // --- COMMAND: PENTEST (Z3) ---
  parser.addCommand('pentest');
  
  // --- COMMAND: QA (Z5) ---
  parser.addCommand('qa');

  // --- COMMAND: UI ---
  final uiCommand = parser.addCommand('ui');
  uiCommand.addOption('type', allowed: ['login', 'splash'], help: 'Type of UI component');

  // --- COMMAND: GENERATE ---
  final generateCommand = parser.addCommand('generate');
  generateCommand.addCommand('model');
  generateCommand.addCommand('flavor');
  generateCommand.addCommand('ai');
  
  final crudCommand = generateCommand.addCommand('crud');
  crudCommand.addOption('name', abbr: 'n', help: 'Name of the class/model');
  crudCommand.addOption('path', abbr: 'p', help: 'Path to JSON file', defaultsTo: 'data.json');
  crudCommand.addOption('state',
      abbr: 's',
      help: 'State Management type',
      allowed: ['getx', 'bloc', 'riverpod', 'provider', 'cubit', 'redux'],
      defaultsTo: 'getx');

  try {
    final results = parser.parse(arguments);

    final ragUrl = 'http://localhost:8000';

    if (results.command?.name == 'log') {
      await LogInjector.run();
      return;
    }

    if (results.command?.name == 'monitor') {
      await PerformanceSurgeon.monitorLive(backendUrl: ragUrl);
      return;
    }
    if (results.command?.name == 'optimize') {
      await PerformanceSurgeon.optimizeProject(backendUrl: ragUrl);
      return;
    }

    if (results.command?.name == 'evolve') {
      final from = results.command!['from'];
      final to = results.command!['to'];
      await EvolveEngine.run(from, to, backendUrl: ragUrl);
      return;
    }

    if (results.command?.name == 'review') {
      await TeamSimulation.run(ragUrl);
      return;
    }
    if (results.command?.name == 'compliance') {
      await ComplianceEngine.run(ragUrl);
      return;
    }
    if (results.command?.name == 'refactor') {
      final filePath = results.command!['file'];
      if (filePath == null) {
        print('Error: --file is required for refactor command');
        exit(1);
      }
      await RefactorAgent.run(filePath, ragUrl);
      return;
    }

    if (results.command?.name == 'changelog') {
      await ReleaseNoteGenerator.run(ragUrl);
      return;
    }
    if (results.command?.name == 'size') {
      await SizeAnalyzer.run();
      return;
    }
    if (results.command?.name == 'a11y') {
      await AccessibilityScanner.run();
      return;
    }
    if (results.command?.name == 'migrate') {
      await MigrateAssistant.run(ragUrl);
      return;
    }
    if (results.command?.name == 'localize') {
      await Localizer.run(ragUrl);
      return;
    }
    if (results.command?.name == 'perf') {
      await PerfAdvisor.run();
      return;
    }

    // 🕵️ Run DEPS DOCTOR
    if (results.command?.name == 'doctor') {
      await DepsDoctor.run();
      return;
    }
    // ...

    // 🧪 Run TEST GENERATOR
    if (results.command?.name == 'test') {
      final filePath = results.command!['file'];
      if (filePath == null) {
        print('Error: --file is required for test command');
        exit(1);
      }
      await TestGenerator.generate(filePath);
      return;
    }

    // 🩹 Run HEAL
    if (results.command?.name == 'heal') {
      final filePath = results.command!['file'];
      if (filePath == null) {
        print('Error: --file is required for heal command');
        exit(1);
      }
      await CodeHealer.run(filePath);
      return;
    }

    // 🕵️ Run Z3: Security Pentest
    if (results.command?.name == 'pentest') {
      await SecurityPentestScanner.run();
      return;
    }

    // 🤖 Run Z5: QA Agent
    if (results.command?.name == 'qa') {
      await QaAgent.run();
      return;
    }

    if (results.command?.name == 'ui') {
      final type = results.command!['type'];
      if (type == 'login') await ComponentGenerator.generateLogin();
      if (type == 'splash') await ComponentGenerator.generateSplash();
      return;
    }

    if (results.command?.name == 'audit') {
      ArchitectureAuditor.audit();
    } else if (results.command?.name == 'mock') {
      await MockServerGenerator.generate();
    } else if (results.command?.name == 'generate') {
      final genCommand = results.command!.command;

      if (genCommand?.name == 'crud') {
        final name = genCommand!['name'];
        final path = genCommand['path'];
        final state = genCommand['state'];

        if (name == null) {
          print('Error: --name is required');
          exit(1);
        }

        final jsonFile = File(path);
        final jsonData = jsonDecode(jsonFile.readAsStringSync());
        await CrudGenerator.generate(name, jsonData, state);
      } else if (genCommand?.name == 'ai') {
        print('Enter RAG Backend URL (default: http://localhost:8000):');
        String? url = stdin.readLineSync();
        if (url == null || url.isEmpty) url = 'http://localhost:8000';
        await RagClientGenerator.generate(url);
      }
    } else {
      _printUsage();
    }
  } catch (e) {
    print('Error: $e');
    _printUsage();
  }
}

void _printUsage() {
  print('╔══════════════════════════════════════════════════╗');
  print('║   🚀 FLUTTER ENGINE-X (FEX) v1.0.0               ║');
  print('║   The Intelligence Layer for Flutter             ║');
  print('╚══════════════════════════════════════════════════╝');
  print('\n🎯 CORE COMMANDS:');
  print('  fex review            # AI Team Simulation (QA/Security/Arch)');
  print('  fex evolve            # Architecture Migration Engine');
  print('  fex pentest           # (Z3) Security Analysis');
  print('  fex qa                # (Z5) Autonomous QA');
  print('\n🩹 MAINTENANCE & DEBUGGING:');
  print('  fex heal --file <p>   # Self-Healing Refactoring');
  print('  fex log               # Inject VS Code Live Inspector');
  print('  fex doctor            # Dependency Intelligence');
  print('  fex perf              # Runtime Performance Advisor');
  print('\n📁 GENERATORS:');
  print('  fex generate crud     # Multi-State Feature Gen');
  print('  fex ui --type <type>  # Premium UI Scaffold');
  print('  fex localize          # AI Semantic Localization');
  print('\n💡 Options:');
  print('  --version             # Show FEX version');
  print('  --help                # Show this help');
}
