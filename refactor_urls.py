import os
import re

URL_MAPPING = {
    "http://192.168.1.252/fintech2/integrasi/android/report/dinas": "ApiServices.reportDinas",
    "http://192.168.1.252/fintech2/integrasi/android/report/izin": "ApiServices.reportIzin",
    "https://192.168.1.252/fintech2/integrasi/android/cuti_izin/all_pegawai": "ApiServices.allPegawai",
    "https://192.168.1.252/fintech2/integrasi/android/cuti_izin/atasan_langsung": "ApiServices.atasanLangsung",
    "https://192.168.1.252/fintech2/integrasi/android/cuti_izin/cuti": "ApiServices.cuti",
    "https://192.168.1.252/fintech2/integrasi/android/cuti_izin/insert_cuti": "ApiServices.insertCuti",
    "https://192.168.1.252/fintech2/integrasi/android/cuti_izin/insert_izin": "ApiServices.insertIzin",
    "https://192.168.1.252/fintech2/integrasi/android/cuti_izin/kategory_izin": "ApiServices.kategoryIzin",
    "https://192.168.1.252/fintech2/integrasi/android/cuti_izin/tipe_izin": "ApiServices.tipeIzin",
    "https://192.168.1.252/fintech2/integrasi/android/insert_absen/login": "ApiServices.insertAbsenLogin",
    "https://192.168.1.252/fintech2/integrasi/android/insert_absen_emergency/login": "ApiServices.insertAbsenEmergencyLogin",
    "https://192.168.1.252/fintech2/integrasi/android/login/login": "ApiServices.login",
    "https://192.168.1.252/fintech2/integrasi/android/login/v_absen": "ApiServices.vAbsen",
    "https://192.168.1.252/fintech2/integrasi/android/lonceng/list_lonceng": "ApiServices.listLonceng",
    "https://192.168.1.252/fintech2/integrasi/android/report/cuti": "ApiServices.reportCuti",
    "https://192.168.1.252/fintech2/integrasi/android/report/dinas": "ApiServices.reportDinas",
    "https://192.168.1.252/fintech2/integrasi/android/report/history_absen": "ApiServices.reportHistoryAbsen",
    "https://192.168.1.252/fintech2/integrasi/android/report/izin": "ApiServices.reportIzin",
    "https://192.168.1.252/fintech2/integrasi/android/report/jadwal_kerja": "ApiServices.reportJadwalKerja",
    "https://192.168.1.252/fintech2/integrasi/android/report/myCuti": "ApiServices.reportMyCuti",
    "https://192.168.1.252/fintech2/integrasi/android/report/myIzin": "ApiServices.reportMyIzin",
    "https://192.168.1.252/fintech2/integrasi/android/report/saldo_koperasi": "ApiServices.reportSaldoKoperasi",
    "https://192.168.1.252/fintech2/integrasi/android/report/ulang_tahun": "ApiServices.reportUlangTahun",
    "https://192.168.1.252/fintech2/integrasi/android/survei/list_survei": "ApiServices.listSurvei",
    "https://garamina.com/erp/assets/upload/": "ApiServices.erpAssetsUrl",
    "https://garamina.com/hr/files/emp/pic/pic_20190624_213733_798.jpeg": "ApiServices.defaultProfilePic",
    "https://garamina.com/login.php": "ApiServices.loginUrl",
    "https://ptgaram.com/api/status_absen_emergency/get_status_absen": "ApiServices.getStatusAbsen",
    "https://ptgaram.com/api/status_absen_emergency/insert_login_emergency": "ApiServices.insertLoginEmergency",
    "https://ptgaram.com/api/status_absen_emergency/insert_status_absen": "ApiServices.insertStatusAbsen",
    "https://ptgaram.com/api/status_absen_emergency/update_checkStatus": "ApiServices.updateCheckStatus"
}

def process_file(filepath):
    if "api_services.dart" in filepath:
        return
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    needed_import = False

    for url, constant in URL_MAPPING.items():
        if url in content:
            needed_import = True
            content = content.replace(f"'{url}'", constant)
            content = content.replace(f'"{url}"', constant)
            content = content.replace(f"'{url}", f"'${{{constant}}}")
            content = content.replace(f'"{url}', f'"${{{constant}}}')

    if needed_import and content != original_content:
        import_stmt = "import 'package:garamina/services/api_services.dart';\n"
        if import_stmt not in content:
            # Try to find the last import statement
            imports = list(re.finditer(r"^import\s+['\"].*?['\"];", content, re.MULTILINE))
            if imports:
                last_import = imports[-1]
                insert_idx = last_import.end() + 1
                content = content[:insert_idx] + import_stmt + content[insert_idx:]
            else:
                content = import_stmt + "\n" + content
                
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
