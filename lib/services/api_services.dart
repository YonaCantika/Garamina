class ApiServices {
  static const String baseUrl = 'http://192.168.1.252/fintech2/integrasi/android/';
  static const String baseUrlEmergency = 'https://ptgaram.com/api/status_absen_emergency/';
  static const String erpAssetsUrl = 'http://192.168.1.252/erp/assets/upload/';
  static const String defaultProfilePic = 'http://192.168.1.252/hr/files/emp/pic/pic_20190624_213733_798.jpeg';
  static const String loginUrl = 'http://192.168.1.252/login.php';

  static const String apiKey = '8deca313c70c6195eba4skshgjsk7979897ss';

  // Cut / Izin
  static const String allPegawai = '${baseUrl}cuti_izin/all_pegawai';
  static const String atasanLangsung = '${baseUrl}cuti_izin/atasan_langsung';
  static const String cuti = '${baseUrl}cuti_izin/cuti';
  static const String insertCuti = '${baseUrl}cuti_izin/insert_cuti';
  static const String insertIzin = '${baseUrl}cuti_izin/insert_izin';
  static const String kategoryIzin = '${baseUrl}cuti_izin/kategory_izin';
  static const String tipeIzin = '${baseUrl}cuti_izin/tipe_izin';

  // Absen
  static const String insertAbsenLogin = '${baseUrl}insert_absen/login';
  static const String insertAbsenEmergencyLogin = '${baseUrl}insert_absen_emergency/login';
  
  // Login
  static const String login = '${baseUrl}login/login';
  static const String vAbsen = '${baseUrl}login/v_absen';

  // Lonceng / Survei
  static const String listLonceng = '${baseUrl}lonceng/list_lonceng';
  static const String listSurvei = '${baseUrl}survei/list_survei';

  // Report
  static const String reportCuti = '${baseUrl}report/cuti';
  static const String reportDinas = '${baseUrl}report/dinas';
  static const String reportHistoryAbsen = '${baseUrl}report/history_absen';
  static const String reportIzin = '${baseUrl}report/izin';
  static const String reportJadwalKerja = '${baseUrl}report/jadwal_kerja';
  static const String reportMyCuti = '${baseUrl}report/myCuti';
  static const String reportMyIzin = '${baseUrl}report/myIzin';
  static const String reportSaldoKoperasi = '${baseUrl}report/saldo_koperasi';
  static const String reportUlangTahun = '${baseUrl}report/ulang_tahun';
  
  // Emergency Status
  static const String getStatusAbsen = '${baseUrlEmergency}get_status_absen';
  static const String insertLoginEmergency = '${baseUrlEmergency}insert_login_emergency';
  static const String insertStatusAbsen = '${baseUrlEmergency}insert_status_absen';
  static const String updateCheckStatus = '${baseUrlEmergency}update_checkStatus';
}
