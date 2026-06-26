# Sentralisasi API ke `lib/services/api_service.dart`

## Latar Belakang

Saat ini terdapat **44 API call** yang tersebar di **20+ file** Dart. Semuanya:
- Menuliskan URL lengkap secara manual (hardcoded)
- Menyalin API key `'8deca313c70c6195eba4skshgjsk7979897ss'` berulang-ulang (42 kali)
- Menggunakan 2 base URL berbeda:
  - `https://192.168.1.252/fintech2/integrasi/android/` (server internal)
  - `https://ptgaram.com/api/` (server emergency publik)

Ini menyulitkan jika ingin mengganti URL atau API key — harus edit di puluhan tempat.

## Proposed Changes

### Service Layer (File Baru)

#### [NEW] [api_service.dart](file:///d:/aa/garamina/garaminav2/lib/services/api_service.dart)

File utama yang berisi:

```dart
class ApiService {
  // Base URLs — cukup ubah di sini saja
  static const String baseUrl = 'https://192.168.1.252/fintech2/integrasi/android';
  static const String emergencyBaseUrl = 'https://ptgaram.com/api';
  static const String apiKey = '8deca313c70c6195eba4skshgjsk7979897ss';

  // Default headers
  static Map<String, String> get _headers => {'APIKEY': apiKey};

  // Helper: POST biasa
  static Future<http.Response> post(String endpoint, {Map<String, String>? body, bool isEmergency = false})

  // Helper: POST dengan custom headers
  static Future<http.Response> postWithHeaders(String endpoint, {Map<String, String>? headers, dynamic body, bool isEmergency = false})

  // Helper: Multipart POST (untuk upload foto)
  static Future<http.StreamedResponse> multipartPost(String endpoint, {required Map<String, String> fields, Map<String, String>? files})
}
```

**Endpoint methods** — setiap API call akan punya method khusus. Contoh:
```dart
// Login
static Future<http.Response> login(String username, String password, String macAddress)

// Absen
static Future<http.StreamedResponse> insertAbsen({required Map<String, String> fields, required String fotoPath})

// Report
static Future<http.Response> getUlangTahun(String tanggal)
static Future<http.Response> getCuti(String mulai, String selesai)
static Future<http.Response> getIzin(String mulai, String selesai)
...
```

---

### File yang Diubah (Update import + ganti http call)

Setiap file di bawah ini akan diubah:
1. **Hapus** `import 'package:http/http.dart' as http;` (jika tidak lagi dipakai langsung)
2. **Tambah** `import 'package:garamina/services/api_service.dart';`
3. **Ganti** setiap `http.post(Uri.parse('https://...'), headers: {'APIKEY': '...'}, body: {...})` menjadi pemanggilan method `ApiService.xxx()`

| # | File | Jumlah API Call | Endpoint |
|---|------|-----------------|----------|
| 1 | [login_page.dart](file:///d:/aa/garamina/garaminav2/lib/login_page.dart) | 5 | login, insert_absen_emergency, lonceng, status_absen_emergency (get/update) |
| 2 | [dashboard_page.dart](file:///d:/aa/garamina/garaminav2/lib/dashboard_page.dart) | 5 | ulang_tahun, cuti, izin, dinas, saldo_koperasi |
| 3 | [absen_page.dart](file:///d:/aa/garamina/garaminav2/lib/absen_page.dart) | 2 | insert_status_absen (emergency), insert_absen (multipart) |
| 4 | [absen_offline_page.dart](file:///d:/aa/garamina/garaminav2/lib/absen_offline_page.dart) | 1 | update_checkStatus (emergency) |
| 5 | [dataAbsen_page.dart](file:///d:/aa/garamina/garaminav2/lib/dataAbsen_page.dart) | 3 | insert_login_emergency, list_survei, v_absen |
| 6 | [dataAbsenOffline_page.dart](file:///d:/aa/garamina/garaminav2/lib/dataAbsenOffline_page.dart) | 1 | insert_absen_emergency |
| 7 | [histori_page.dart](file:///d:/aa/garamina/garaminav2/lib/histori_page.dart) | 1 | history_absen |
| 8 | [cuti_page.dart](file:///d:/aa/garamina/garaminav2/lib/cuti_page.dart) | 1 | cuti |
| 9 | [izin_page.dart](file:///d:/aa/garamina/garaminav2/lib/izin_page.dart) | 1 | izin |
| 10 | [dinas_page.dart](file:///d:/aa/garamina/garaminav2/lib/dinas_page.dart) | 1 | dinas |
| 11 | [hr_page.dart](file:///d:/aa/garamina/garaminav2/lib/hr_page.dart) | 3 | cuti, izin, dinas |
| 12 | [notif_page.dart](file:///d:/aa/garamina/garaminav2/lib/notif_page.dart) | 2 | list_lonceng, list_survei |
| 13 | [survei_page.dart](file:///d:/aa/garamina/garaminav2/lib/survei_page.dart) | 1 | list_survei |
| 14 | [jadwal_page.dart](file:///d:/aa/garamina/garaminav2/lib/jadwal_page.dart) | 1 | jadwal_kerja |
| 15 | [knowledge_page.dart](file:///d:/aa/garamina/garaminav2/lib/knowledge_page.dart) | 1 | cuti |
| 16 | [helpdesk_page.dart](file:///d:/aa/garamina/garaminav2/lib/helpdesk_page.dart) | 1 | cuti |
| 17 | [doc_erp_page.dart](file:///d:/aa/garamina/garaminav2/lib/doc_erp_page.dart) | 1 | cuti |
| 18 | [ulangTahun_page.dart](file:///d:/aa/garamina/garaminav2/lib/ulangTahun_page.dart) | 1 | ulang_tahun |
| 19 | [statusPengajuanCuti_Page.dart](file:///d:/aa/garamina/garaminav2/lib/statusPengajuanCuti_Page.dart) | 1 | myCuti |
| 20 | [statusPengajuanIzin_page.dart](file:///d:/aa/garamina/garaminav2/lib/statusPengajuanIzin_page.dart) | 1 | myIzin |
| 21 | [form_cuti.dart](file:///d:/aa/garamina/garaminav2/lib/components/form_cuti.dart) | 4 | all_pegawai, cuti, atasan_langsung, insert_cuti |
| 22 | [form_izin.dart](file:///d:/aa/garamina/garaminav2/lib/components/form_izin.dart) | 5 | all_pegawai, atasan_langsung, kategory_izin, tipe_izin, insert_izin |

---

## Open Questions

> [!IMPORTANT]
> **Apakah Anda ingin setiap endpoint punya method sendiri-sendiri** (misal `ApiService.login()`, `ApiService.getCuti()`, dll) **atau cukup helper umum saja** (misal `ApiService.post('login/login', body: {...})`) supaya file `api_service.dart` tidak terlalu panjang?
> 
> Rekomendasi saya: **Helper umum saja** (`post`, `postWithHeaders`, `multipartPost`) + konstanta endpoint. Ini lebih ringkas dan mudah ditambah endpoint baru.

## Verification Plan

### Automated Tests
- `flutter analyze` — memastikan tidak ada error setelah refactoring

### Manual Verification
- Jalankan `flutter run` dan pastikan fitur login, absen, dashboard tetap berfungsi normal
