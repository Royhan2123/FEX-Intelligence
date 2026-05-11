# 🕵️ Security Scan Report
Generated: 2026-05-11 18:36:02.699921

## Summary
| Severity | Count |
|---|---|
| 🚨 Critical | 2 |
| 🔴 High | 4 |
| 🟡 Medium | 2 |
| Total | 8 |

---
**[HIGH] INSECURE_HTTP**
- File: `\lib\src\architecture_auditor.dart:34`
- Description: Koneksi HTTP (bukan HTTPS) ditemukan. Rentan terhadap Man-in-the-Middle attack.
- Code: `if (content.contains('http://') || content.contains('https://')) {`

---
**[HIGH] INSECURE_HTTP**
- File: `\lib\src\qa_agent.dart:15`
- Description: Koneksi HTTP (bukan HTTPS) ditemukan. Rentan terhadap Man-in-the-Middle attack.
- Code: `QaAgent({this.ragBackendUrl = 'http://localhost:8000'});`

---
**[HIGH] INSECURE_HTTP**
- File: `\lib\src\qa_agent.dart:17`
- Description: Koneksi HTTP (bukan HTTPS) ditemukan. Rentan terhadap Man-in-the-Middle attack.
- Code: `static Future<void> run({String backendUrl = 'http://localhost:8000'}) async {`

---
**[CRITICAL] INSECURE_STORAGE**
- File: `\lib\src\security_scanner.dart:103`
- Description: Token/secret tersimpan di SharedPreferences (tidak terenkripsi!). Gunakan flutter_secure_storage.
- Code: `RegExp(r'''SharedPreferences.*(?:token|secret|password|key)''', caseSensitive: false),`

---
**[HIGH] INSECURE_HTTP**
- File: `\lib\src\security_scanner.dart:126`
- Description: Koneksi HTTP (bukan HTTPS) ditemukan. Rentan terhadap Man-in-the-Middle attack.
- Code: `if (lines[i].contains('Uri.http(') || lines[i].contains("'http://")) {`

---
**[CRITICAL] SSL_VERIFICATION_DISABLED**
- File: `\lib\src\security_scanner.dart:138`
- Description: Verifikasi SSL dinonaktifkan! Sangat berbahaya di production.
- Code: `if (lines[i].contains('badCertificateCallback') && lines[i].contains('true')) {`

---
**[MEDIUM] INSECURE_RANDOM**
- File: `\lib\src\security_scanner.dart:235`
- Description: math.Random() tidak aman untuk kebutuhan kriptografi. Gunakan dart:math Random.secure().
- Code: `if (lines[i].contains('math.Random()') &&`

---
**[MEDIUM] INSECURE_RANDOM**
- File: `\lib\src\security_scanner.dart:240`
- Description: math.Random() tidak aman untuk kebutuhan kriptografi. Gunakan dart:math Random.secure().
- Code: `description: 'math.Random() tidak aman untuk kebutuhan kriptografi. Gunakan dart:math Random.secure().',`
