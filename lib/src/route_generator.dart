import 'dart:io';

class RouteGenerator {
  static Future<void> add(String path, String screenName) async {
    print('🛣️ Adding route $path for $screenName...');
    
    final routerFile = File('lib/core/router/app_router.dart');
    if (!routerFile.existsSync()) {
      if (!routerFile.parent.existsSync()) routerFile.parent.createSync(recursive: true);
      routerFile.writeAsStringSync('// FEX Router Configuration\nclass AppRoutes {}\n');
    }

    var content = routerFile.readAsStringSync();
    final newRoute = '  static const String ${_toConstantName(screenName)} = \'$path\';\n';
    
    if (!content.contains(newRoute)) {
      content = content.replaceFirst('class AppRoutes {', 'class AppRoutes {\n$newRoute');
      routerFile.writeAsStringSync(content);
    }
    
    print('✅ Route added to lib/core/router/app_router.dart');
  }

  static String _toConstantName(String name) {
    return name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => '_${match.group(1)!.toLowerCase()}').substring(1).toUpperCase();
  }
}
