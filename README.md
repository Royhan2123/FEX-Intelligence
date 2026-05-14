<div align="center">

# 🚀 FEX Intelligence

**The Advanced Architecture & Intelligence Layer for Flutter Applications**

[![Pub Version](https://img.shields.io/pub/v/fex_intelligence)](https://pub.dev/packages/fex_intelligence)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[Documentation Portal](https://fex-intelligence.vercel.app/) • [Security Audit](https://github.com/Royhan2123/FEX-Intelligence/issues)

</div>

---

FEX Intelligence is an enterprise-grade CLI designed to ensure **structural consistency, architectural integrity, and security compliance** in Flutter projects. Unlike simple generators, FEX utilizes multi-agent AI analysis to assist developers in refactoring, migrating, and auditing complex codebases.

## 🏛️ Core Identity: Architecture Intelligence

FEX focuses on the "Hard Problems" of Flutter development:
*   **Intelligent Migration:** Safely evolve your state management (e.g., GetX to Riverpod).
*   **Security Auditing:** Detect leaked secrets, insecure manifest rules, and weak configs.
*   **Structural Refactoring:** Identify code smells and suggest architectural improvements.
*   **Multi-Agent Review:** Get feedback from specialized AI agents (Architect, Security, QA).

---

## ⚙️ Installation

Install globally via pub.dev:

```bash
dart pub global activate fex_intelligence
```

Configure your AI Engine (Gemini 1.5 Pro supported):

```bash
fex config --key YOUR_GEMINI_API_KEY
```

---

## 🧰 Command Reference

### 🧠 Architecture Intelligence

| Command                                | Description                                                                         |
| -------------------------------------- | ----------------------------------------------------------------------------------- |
| `fex review`                           | Multi-agent analysis (Architect, Security, QA) providing structural feedback.        |
| `fex evolve --from getx --to riverpod` | Assists in architecture migration by suggesting logic rewrites and structural shifts. |
| `fex refactor -f <file>`               | Suggests architectural patches and code smell removals for a specific file.         |
| `fex audit`                            | Scans for security vulnerabilities, secret leaks, and architectural non-compliance. |

### 🛡️ Reliability & Security

| Command                           | Description                                                                     |
| --------------------------------- | ------------------------------------------------------------------------------- |
| `fex log`                         | Injects a real-time network and state inspector for debugging.                  |
| `fex doctor`                      | Analyzes dependency health, detecting abandoned or insecure packages.           |
| `fex release <patch/minor/major>` | Manages versioning and generates intelligent changelogs.                        |
| `fex sign`                        | Streamlines Android Keystore management and App Signing configurations.         |
| `fex env setup`                   | Automates secure multi-flavor environment variable management.                  |

### ⚡ Automation & Productivity

| Command                            | Description                                                             |
| ---------------------------------- | ----------------------------------------------------------------------- |
| `fex init`                         | Bootstraps a project using clean architecture standards.                |
| `fex generate crud -n User`        | Scaffolds complete features (Repository, Service, Model, Controller).   |
| `fex ui --type login`              | Generates customizable, theme-aware UI scaffolds.                       |
| `fex l10n init`                    | Automates the setup of internationalization and ARB files.              |
| `fex asset sync`                   | Generates type-safe references for all project assets.                  |
| `fex rename`                       | Safely renames package names and bundle identifiers across platforms.   |
| `fex permission`                   | Synchronizes and manages Android/iOS permission declarations.           |
| `fex icon / fex splash`            | Generates native icons and splash screens from source images.           |

---

## 🛡️ Trust & Safety

FEX is designed with a **"Developer-First"** approach to safety:
*   **Preview Mode:** Destructive commands suggest changes instead of overwriting them immediately.
*   **Non-Destructive Scanning:** Audits are read-only and do not alter your source code.
*   **Version Control Aware:** We recommend running FEX commands on a clean git state for easy rollbacks.

## 📖 Full Documentation

Visit the **[FEX Documentation Portal](https://fex-intelligence.vercel.app/)** for technical deep-dives, architecture diagrams, and real-world implementation examples.

## 📄 License

MIT License - see the [LICENSE](LICENSE) file for details.
