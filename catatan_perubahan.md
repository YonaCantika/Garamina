# Catatan Perubahan (Changelog) - Garamina ke Garamina V2

Dokumen ini mencatat semua perubahan besar yang dilakukan dari proyek `garamina`.

## 1. Pembaruan Dependensi (pubspec.yaml)
Beberapa package Flutter (dependensi) telah diperbarui ke versi yang lebih baru. 
**Alasan:** Pembaruan ini diperlukan untuk menyesuaikan dengan versi SDK Flutter/Dart yang lebih baru (mendukung Flutter 3.41.2), memperbaiki *bug* bawaan dari library lama, dan meningkatkan keamanan serta performa.

**Daftar Perubahan Dependensi Utama:**
- `image_picker`: diperbarui dari `^0.8.4+4` menjadi `^1.1.2`
- `carousel_slider`: diperbarui dari `^4.2.1` menjadi `^5.0.0`
- `permission_handler`: diperbarui dari `^11.0.0` menjadi `^12.0.0`
- `geocoding`: diperbarui dari `^2.1.1` menjadi `^3.0.0`
- `file_picker`: diperbarui dari `^6.1.1` menjadi `^8.0.3`
- `fluttertoast`: diperbarui dari `^8.2.4` menjadi `^9.1.0`
- `webview_flutter`: diperbarui dari `^2.0.13` menjadi `^4.8.0`
- Ditambahkan `image: ^4.2.0`

Selain itu, ditambahkan blok `dependency_overrides` untuk memaksa resolusi konflik dependensi (seperti `win32`, `shared_preferences_foundation`, dll.) yang sering terjadi saat melakukan upgrade versi Flutter.

## 2. Penggantian `device_info` menjadi `android_id`
- **Perubahan:** Package `device_info: ^2.0.0` dihapus dan digantikan dengan `android_id: ^0.4.0`.
- **Fungsi:** Digunakan untuk mengambil ID unik perangkat (Device ID) untuk keperluan autentikasi atau pelacakan perangkat pengguna saat login/absensi.
- **Alasan:** Cara lama untuk mengambil ID perangkat via `device_info` sudah banyak yang *deprecated* dan berpotensi mengalami isu kompatibilitas pada Android versi terbaru. Package `android_id` dirancang khusus untuk memanggil Android ID dengan lebih stabil. Perubahan ini juga diterapkan pada logika kode di `login_page.dart`.

## 3. Sentralisasi URL API dan API Key (Refactoring)
- **Perubahan:** Penambahan file baru `lib/services/api_services.dart`. File-file di dalam folder `lib/` yang sebelumnya mengandung URL API secara langsung (hardcoded) telah diubah untuk merujuk ke file ini.
- **Fungsi:** Mengelompokkan semua rute endpoint API (seperti `ApiServices.login`, `ApiServices.getStatusAbsen`) serta konstanta `APIKEY` ke dalam satu tempat/file layanan (service).
- **Alasan:** Praktik sebelumnya (*hardcode* API di setiap halaman) sangat tidak dianjurkan. Dengan sentralisasi ini, *maintenance* akan jauh lebih mudah. Jika suatu saat domain server atau API Key berubah, Anda hanya perlu mengubahnya di satu file (`api_services.dart`) tanpa perlu repot mencari dan menggantinya di puluhan file UI yang ada. *(Perubahan ini dieksekusi secara otomatis dibantu oleh script Python yang ada di root direktori).*

## 4. Code Modernization (Perbaikan Sintaks Flutter Usang)
- **Perubahan:** Memperbaiki peringatan kode yang sudah *deprecated* (usang).
- **Contoh:** Pada penggunaan `ElevatedButton.styleFrom()`, parameter `primary` diubah menjadi `backgroundColor` (misalnya pada file `login_page.dart` dan lainnya).
- **Alasan:** Flutter terus memperbarui standardisasi kodenya (terutama saat transisi ke Material Design 3). Memperbaiki sintaks yang usang ini penting untuk memastikan proyek dapat dicompile dengan lancar pada versi Flutter masa depan tanpa pesan error atau peringatan (warning).
