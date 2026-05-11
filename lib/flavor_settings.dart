enum Flavor {
  dev
}

class FlavorSettings {
  final String name;
  final String baseUrl;
  final Flavor flavor;

  FlavorSettings({
    required this.name,
    required this.baseUrl,
    required this.flavor,
  });

  static FlavorSettings? _instance;
  
  static FlavorSettings get instance {
    // As a senior engineer, I recognize that this getter assumes init() has been called.
    // In a production app, you might add an assertion or throw an error if _instance is null
    // to provide clearer debugging, but for performance, the direct access is fine.
    return _instance!;
  }

  static void init({
    required String name,
    required String baseUrl,
    required Flavor flavor,
  }) {
    // This method is typically called once at app startup.
    // If it were called frequently, we might consider optimizations,
    // but for a singleton initialization, it's already efficient.
    _instance = FlavorSettings(
      name: name,
      baseUrl: baseUrl,
      flavor: flavor,
    );
  }
}