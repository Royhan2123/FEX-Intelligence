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
import '../lib/src/ai_engine.dart';         // STANDALONE AI
import '../lib/src/model_generator.dart';    // MODEL GEN
import '../lib/src/env_manager.dart';       // ENV
import '../lib/src/signing_manager.dart';   // SIGN
import '../lib/src/project_renamer.dart';   // RENAME
import '../lib/src/permission_manager.dart'; // PERMISSION
import '../lib/src/bootstrapper.dart';      // INIT
import '../lib/src/icon_generator.dart';    // ICON
import '../lib/src/splash_generator.dart';  // SPLASH
import '../lib/src/cicd_manager.dart';      // CICD
import '../lib/src/widget_generator.dart';  // WIDGET
import '../lib/src/route_generator.dart';   // ROUTE
import '../lib/src/flavor_generator.dart'; // FLAVOR
import '../lib/src/asset_pipeline.dart';   // ASSET
import '../lib/src/l10n_generator.dart';    // L10N
import '../lib/src/figma_sync.dart';       // FIGMA
import '../lib/src/release_generator.dart'; // RELEASE
import '../lib/src/deeplink_validator.dart'; // DEEPLINK

void main(List<String> arguments) async {
  final parser = ArgParser();

  // --- COMMAND: GLOBAL CONFIG ---
  parser.addFlag('version', abbr: 'v', negatable: false, help: 'Show FEX version');
  
  final configCommand = parser.addCommand('config');
  configCommand.addOption('key', help: 'Set your Gemini API Key');

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

  // --- NEW COMMANDS FROM ROADMAP ---
  final envCommand = parser.addCommand('env');
  envCommand.addCommand('setup');
  envCommand.addCommand('generate');

  final l10nCommand = parser.addCommand('l10n');
  l10nCommand.addCommand('init');
  l10nCommand.addCommand('generate');

  final assetCommand = parser.addCommand('asset');
  assetCommand.addCommand('sync');

  final figmaCommand = parser.addCommand('figma');
  figmaCommand.addOption('token', help: 'Figma API Token');
  figmaCommand.addOption('file', help: 'Figma File ID');

  final releaseCommand = parser.addCommand('release');
  releaseCommand.addCommand('patch');
  releaseCommand.addCommand('minor');
  releaseCommand.addCommand('major');

  final deeplinkCommand = parser.addCommand('deeplink');
  deeplinkCommand.addCommand('check');

  // --- THE HIGH IMPACT TRIO ---
  final signCommand = parser.addCommand('sign');
  signCommand.addOption('alias', abbr: 'a', help: 'Key Alias', defaultsTo: 'upload');
  signCommand.addOption('pass', abbr: 'p', help: 'Key Password', defaultsTo: 'password123');

  final renameCommand = parser.addCommand('rename');
  renameCommand.addOption('name', help: 'New package name (e.g. com.company.app)');

  final permissionCommand = parser.addCommand('permission');
  permissionCommand.addOption('add', help: 'Comma separated permissions (camera,location,microphone)');

  // --- NEW COMMANDS FROM ROADMAP ---
  final initCommand = parser.addCommand('init');
  initCommand.addOption('name', help: 'Project Name');
  initCommand.addOption('arch', help: 'Architecture (clean)', defaultsTo: 'clean');

  final iconCommand = parser.addCommand('icon');
  iconCommand.addOption('set', help: 'Path to source icon');

  final splashCommand = parser.addCommand('splash');
  splashCommand.addOption('set', help: 'Path to source splash image');
  splashCommand.addOption('color', help: 'Background color', defaultsTo: '#FFFFFF');

  final cicdCommand = parser.addCommand('cicd');
  cicdCommand.addOption('provider', help: 'CI/CD Provider (github)', defaultsTo: 'github');

  final widgetCommand = parser.addCommand('widget');
  widgetCommand.addOption('name', help: 'Widget Name');
  widgetCommand.addOption('type', help: 'Type (stateless, stateful)', defaultsTo: 'stateless');

  final routeCommand = parser.addCommand('route');
  routeCommand.addOption('path', help: 'Route path');
  routeCommand.addOption('screen', help: 'Screen name');

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
  final genModelCommand = generateCommand.addCommand('model');
  genModelCommand.addOption('name', abbr: 'n', help: 'Class name');
  genModelCommand.addOption('path', abbr: 'p', help: 'Path to JSON file', defaultsTo: 'data.json');
  final genFlavorCommand = generateCommand.addCommand('flavor');
  genFlavorCommand.addCommand('init');
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

    if (results['version'] == true) {
      print('╔══════════════════════════════════════════════════╗');
      print('║   🚀 FLUTTER ENGINE-X (FEX) v1.0.2               ║');
      print('╚══════════════════════════════════════════════════╝');
      return;
    }

    final ragUrl = 'http://localhost:8000';

    if (results.command?.name == 'config') {
      final key = results.command!['key'];
      if (key != null) {
        await AIEngine.saveKey(key);
      } else {
        print('Usage: fex config --key AIza...');
      }
      return;
    }

    if (results.command?.name == 'log') {
      await LogInjector.run();
      return;
    }

    if (results.command?.name == 'monitor') {
      await PerformanceSurgeon.monitorLive();
      return;
    }
    if (results.command?.name == 'optimize') {
      await PerformanceSurgeon.optimizeProject();
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

    // --- NEW COMMAND IMPLEMENTATIONS ---
    if (results.command?.name == 'env') {
      final envSub = results.command!.command;
      if (envSub?.name == 'setup') await EnvManager.setup();
      if (envSub?.name == 'generate') await EnvManager.generate();
      return;
    }

    if (results.command?.name == 'l10n') {
      final l10nSub = results.command!.command;
      if (l10nSub?.name == 'init') await L10nGenerator.init(['en', 'id']);
      if (l10nSub?.name == 'generate') await L10nGenerator.generate();
      return;
    }

    if (results.command?.name == 'asset') {
      if (results.command!.command?.name == 'sync') await AssetPipeline.sync();
      return;
    }

    if (results.command?.name == 'figma') {
      final token = results.command!['token'];
      final fileId = results.command!['file'];
      if (token != null && fileId != null) {
        await FigmaSync.pull(token, fileId);
      } else {
        print('Usage: fex figma --token <T> --file <F>');
      }
      return;
    }

    if (results.command?.name == 'release') {
      final type = results.command!.command?.name ?? 'patch';
      await ReleaseGenerator.generate(type);
      return;
    }

    if (results.command?.name == 'deeplink') {
      if (results.command!.command?.name == 'check') await DeeplinkValidator.check();
      return;
    }

    if (results.command?.name == 'sign') {
      final alias = results.command!['alias'];
      final pass = results.command!['pass'];
      await SigningManager.generate(alias, pass);
      return;
    }

    if (results.command?.name == 'rename') {
      final name = results.command!['name'];
      if (name != null) await ProjectRenamer.rename(name);
      else print('Error: --name is required for rename');
      return;
    }

    if (results.command?.name == 'permission') {
      final perms = results.command!['add'];
      if (perms != null) {
        await PermissionManager.add(perms.split(','));
      } else {
        print('Usage: fex permission --add camera,location');
      }
      return;
    }

    if (results.command?.name == 'init') {
      final name = results.command!['name'] ?? 'fex_project';
      final arch = results.command!['arch'] ?? 'clean';
      await ProjectBootstrapper.init(name, arch);
      return;
    }

    if (results.command?.name == 'icon') {
      final path = results.command!['set'];
      if (path != null) await IconGenerator.setIcon(path);
      return;
    }

    if (results.command?.name == 'splash') {
      final path = results.command!['set'];
      final color = results.command!['color'] ?? '#FFFFFF';
      if (path != null) await SplashGenerator.setSplash(path, color: color);
      return;
    }

    if (results.command?.name == 'cicd') {
      final provider = results.command!['provider'] ?? 'github';
      await CicdManager.init(provider);
      return;
    }

    if (results.command?.name == 'widget') {
      final name = results.command!['name'];
      final type = results.command!['type'] ?? 'stateless';
      if (name != null) await WidgetGenerator.create(name, type);
      return;
    }

    if (results.command?.name == 'route') {
      final path = results.command!['path'];
      final screen = results.command!['screen'];
      if (path != null && screen != null) await RouteGenerator.add(path, screen);
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
        
        // Fix: Explicitly handle GetX default
        final effectiveState = state ?? 'getx';
        await CrudGenerator.generate(name, jsonData, effectiveState);
      } else if (genCommand?.name == 'model') {
        final name = genCommand!['name'];
        final path = genCommand['path'];

        if (name == null) {
          print('Error: --name is required for model generation');
          exit(1);
        }

        final jsonFile = File(path);
        if (!jsonFile.existsSync()) {
          print('Error: JSON file not found at $path');
          exit(1);
        }
        
        final jsonData = jsonDecode(jsonFile.readAsStringSync());
        await ModelGenerator.generate(name, jsonData);
      } else if (genCommand?.name == 'ai') {
        print('Enter RAG Backend URL (default: http://localhost:8000):');
        String? url = stdin.readLineSync();
        if (url == null || url.isEmpty) url = 'http://localhost:8000';
        await RagClientGenerator.generate(url);
      } else if (genCommand?.name == 'flavor') {
        if (genCommand!.command?.name == 'init') await FlavorGenerator.init();
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
  print('  fex generate flavor   # (NEW) Android/iOS Flavor Setup');
  print('  fex ui --type <type>  # Premium UI Scaffold');
  print('  fex env setup         # (NEW) Multi-Flavor Environment');
  print('  fex l10n init         # (NEW) Localization setup');
  print('  fex asset sync        # (NEW) Asset Pipeline');
  print('  fex release patch     # (NEW) Version & Changelog');
  print('  fex figma pull        # (NEW) Figma Theme Sync');
  print('  fex deeplink check    # (NEW) Deep Link Validator');
  print('  fex sign --alias <a>  # (HOT) Android Keystore Manager');
  print('  fex rename --name <n> # (HOT) Project Package Renamer');
  print('  fex permission --add  # (HOT) Sync Android/iOS Permissions');
  print('  fex init --name <n>   # (NEW) Project Bootstrapper');
  print('  fex icon --set <p>    # (NEW) App Icon Generator');
  print('  fex splash --set <p>  # (NEW) Native Splash Screen');
  print('  fex cicd init         # (NEW) CI/CD Pipeline Generator');
  print('  fex widget --name <n> # (NEW) Custom Widget Generator');
  print('  fex route --path <p>  # (NEW) Route Generator');
  print('  fex localize          # AI Semantic Localization');
  print('\n💡 Options:');
  print('  --version             # Show FEX version');
  print('  --help                # Show this help');
}
