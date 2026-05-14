import 'package:fex_intelligence/fex_intelligence.dart';

/// ===========================================================================
/// FEX Intelligence (Flutter Engine-X) - Comprehensive Usage Examples
/// ===========================================================================
/// 
/// FEX is primarily a Command Line Interface (CLI). Most users will interact
/// with it via terminal commands. However, you can also access some internal
/// logic programmatically as shown below.
///
/// ---------------------------------------------------------------------------
/// TERMINAL COMMAND EXAMPLES:
/// ---------------------------------------------------------------------------
/// 
/// 🧠 GOD-LEVEL INTELLIGENCE
/// $ fex review                      # AI Team review (QA, Security, Architect)
/// $ fex evolve --from mvc --to clean # Auto-refactor architecture
/// $ fex heal                        # Self-healing code (patches errors)
/// $ fex refactor -f lib/main.dart   # Specific file AI refactor
/// 
/// 🛡️ DEVOPS & SECURITY
/// $ fex pentest                     # Security vulnerability scan
/// $ fex log                         # Inject Live Network Inspector
/// $ fex cicd                        # Generate CI/CD Workflows
/// $ fex release patch               # Smart versioning & changelog
/// 
/// ⚡ PERFORMANCE & MAINTENANCE
/// $ fex monitor                     # Live project health monitoring
/// $ fex optimize                    # Extreme runtime optimizations
/// $ fex doctor                      # Dependency health & abandoned pkg check
/// $ fex size                        # Analyze app bundle size
/// 
/// 🛠️ GENERATORS & AUTOMATION
/// $ fex init                        # Setup enterprise project structure
/// $ fex generate crud -n Product    # Full CRUD (Model, Repo, Service, State)
/// $ fex ui --type login             # Generate modern UI screens
/// $ fex figma --token <T> --file <F> # Sync design tokens from Figma
/// $ fex localize                    # AI Semantic translation (.arb)
///
/// ---------------------------------------------------------------------------

void main() async {
  print('--- FEX Intelligence Programmatic Example ---');

  // Note: Most FEX features require a Gemini API Key to be configured first:
  // fex config --key AIza...

  try {
    print('Testing AI Engine connection...');
    final response = await AIEngine.ask(
      'Explain why Clean Architecture is important for large Flutter projects.'
    );
    print('\nAI Response:');
    print(response);
    
    print('\nFEX successfully initialized.');
  } catch (e) {
    print('\n[Note] AI Engine is not configured. Run "fex config --key YOUR_KEY" in terminal.');
    print('Error details: $e');
  }
}
