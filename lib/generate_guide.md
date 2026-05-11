# 🚀 Flutter CLI Generate - Ultimate Guide

Selamat! CLI kamu sekarang sudah mendukung arsitektur profesional dengan fitur interaktif dan infrastruktur jaringan otomatis.

## 📋 Daftar Perintah Utama

### 1. Generate Model (Interaktif)
Membuat class model data. Kamu akan ditanya konfigurasi (Required, copyWith, dll).
```powershell
# Format Manual
dart bin/flutter_cli_generate.dart generate model -n User -f "id:int,name:string"

# Format JSON (Copas)
dart bin/flutter_cli_generate.dart generate model -n Profile -f '{"id":1, "name":"Aris"}'

# Dari File JSON
dart bin/flutter_cli_generate.dart generate model -n Estate -s "book.json"
```

### 2. Generate Feature (Full Infrastructure)
Paling direkomendasikan! Membuat Model, Service, dan Repository. Juga otomatis membangun folder Network.
```powershell
dart bin/flutter_cli_generate.dart generate feature -n Product -s "product.json"
```

---

## 🛠️ Fitur Unggulan (Interactive)

Saat menjalankan perintah di atas, kamu akan diminta memilih:
1.  **Set all fields as REQUIRED?**: Jika `y`, field tidak akan nullable.
2.  **Add copyWith method?**: Menambah fungsi duplikasi object.
3.  **Add fromJson/toJson?**: Menambah fungsi mapping JSON.
4.  **Select HTTP Package**: Pilih antara **Dio**, **Http**, atau **GetConnect**.

---

## 📁 Struktur Folder yang Dihasilkan
CLI ini mengikuti pola Clean Data Layer:
- `lib/data/models/` : Data class & JSON mapping.
- `lib/data/services/` : HTTP Request logic.
- `lib/data/repositories/` : Data orchestrator (penghubung UI & Service).
- `lib/data/network/` : `api_client.dart` (Base Client) & `endpoints.dart` (URL List).

---

## ⚡ Cara Menjalankan Secara Global
Agar tidak perlu mengetik `dart bin/flutter_cli_generate.dart` terus-menerus, jalankan:
```powershell
dart pub global activate --source path .
```
Setelah itu, kamu cukup ketik:
`flutter_cli_generate generate feature -n User -s "data.json"`

---
*Dibuat dengan ❤️ untuk produktivitas Flutter kamu.*
