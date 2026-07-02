# Catatan Perubahan (Changelog) - Garamina by Yona Cantika Pens

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

## 5. Pembaruan Logika Pencatatan Jarak Absensi
- **Perubahan:** Memperbarui parameter `jarak` yang dikirim ke server dengan logika kondisional. Jika karyawan sedang berada di kantor (tidak dinas), nilai `jarak` yang dikirim adalah `0.0`. Namun jika karyawan sedang dinas (SPPD/Detasering/Emergency), jarak yang sesungguhnya (real-time) antara pengguna dan titik koordinat kantor akan dikirimkan secara akurat.
- **File yang dimodifikasi:** 
  - `lib/absen_page.dart` (Fungsi `_saveAbsenData` ditambahkan variabel `isDinas` dan mem-parsing parameter `jarakToSend` ke `_accessAPI`).
  - `lib/absen_offline_page.dart` (Metode absen offline yang secara default berfungsi untuk absen darurat, nilai jarak langsung dipassing secara real).
- **Fungsi:** Memastikan karyawan yang sedang melakukan dinas, jaraknya tetap dicatat secara aktual pada *form data* yang dikirimkan, sementara karyawan yang ngantor biasa tetap tercatat `0.0`.
- **Alasan:** Pada sistem sebelumnya, nilai `jarak` dipaksa selalu `0.0` meskipun karyawan absen dari kejauhan karena dinas, yang menyebabkan laporan riwayat absensi menjadi kurang deskriptif.

02/07/2026
## 6. Penambahan API Key Khusus Darurat
- **File:** `lib/services/api_services.dart`
- **Perubahan:** Menambahkan variabel khusus `apiKeyEmergency = '8deca313c70c6195eba4208b8dc6d56b'` untuk semua *endpoint* darurat.
- **Alasan:** Server `ptgaram.com` menolak semua *request* dari aplikasi karena aplikasi menggunakan API Key yang sama dengan server lokal.

## 7. Perbaikan Fitur Login Darurat (Fallback)
- **File:** `lib/login_page.dart`
- **Perbaikan Timeout & Transisi Darurat:** Menambahkan `timeout(Duration(seconds: 10))` pada API login lokal. Mengubah blok `catch (e)` agar otomatis memicu `getDataEmergency` saat koneksi mati total, menghindari *infinite loading*.
- **Validasi Login Darurat:** Mengubah *header* API ke `apiKeyEmergency`. Mengecek keberadaan `idPeg` dari respon server PT Garam untuk mencegah masuk jika kredensial ditolak. Menampilkan balasan mentah dari server ke layar (mempermudah *debugging*).

## 8. Pelacakan Kegagalan Sinkronisasi Akun
- **File:** `lib/dataAbsen_page.dart`
- **Perubahan:** Mengubah *header* `shareDataEmergency()` menggunakan `apiKeyEmergency`. Menambahkan pesan `print()` log saat sukses, gagal, atau *error*.
- **Alasan:** Sebelumnya jika proses titip data akun ke server PT Garam gagal, aplikasi diam saja, membuat pengguna kesulitan melacak penyebab *Error 500*.

## 9. Pencegahan Crash (Layar Merah) di Absen Offline
- **File:** `lib/absen_offline_page.dart`
- **Perubahan:** Menambahkan *try-catch* dan variabel pengganti. Jika koordinat terbaca `"null"`, ia menggunakan `0.0`. Mengubah *header* `updateStatusEmergency()` ke `apiKeyEmergency`.
- **Alasan:** Mencegah *crash* (FormatException: Invalid double) saat mencoba menghitung jarak kantor dari tulisan "null" akibat penolakan server darurat sebelumnya.
