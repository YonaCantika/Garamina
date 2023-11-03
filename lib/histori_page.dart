import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'dashboard_page.dart';
import 'notif_page.dart';
import 'akun_page.dart';
import 'dataAbsen_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';
import 'auth_state.dart';

class HistoriPage extends StatefulWidget {
  @override
  _HistoriPageState createState() => _HistoriPageState();
}

class _HistoriPageState extends State<HistoriPage> {
  int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> cutiData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final authState = Provider.of<AuthState>(context);
    final apiUrl = Uri.parse('https://garamina.com/fintech2/integrasi/android/report/history_absen');
    // final now = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM').format(now);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        "periodeTanggal": '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        "idPegawai": authState.idPeg
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        cutiData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }



  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori'),
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          // Bagian 1: Selamat Datang dengan Background Biru
          WelcomeSection(),
          // Bagian 2: Carousel Slider
          CarouselSection(),
          // Bagian 3: ListView dengan Border Radius di Atas
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Judul "Karyawan Cuti"
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Histori Absen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Daftar data ListView
                  Expanded(
                    child: cutiData.isEmpty
                        ? const Center(
                      child: Text('Loading...'), // Tampilkan teks "Loading..." ketika data masih kosong
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: cutiData.length,
                      itemBuilder: (context, index) {
                        final tanggal = cutiData[index]['TANGGAL'];
                        final keterangan = cutiData[index]['KETERANGAN'];

                        final fotoIn = 'https://garamina.com/erp/assets/upload/${cutiData[index]['FOTO_IN']}';
                        final jarakIn = cutiData[index]['JARAK_IN'];
                        final jamIn = cutiData[index]['JAM_IN'];
                        final statusAbsenIn = cutiData[index]['STATUS_ABSEN_IN'];

                        final fotoOut = 'https://garamina.com/erp/assets/upload/${cutiData[index]['FOTO_OUT']}';
                        final jarakOut = cutiData[index]['JARAK_OUT'];
                        final jamOut = cutiData[index]['JAM_OUT'];
                        final statusAbsenOut = cutiData[index]['STATUS_ABSEN_OUT'];
                        final nilaiInsentif = cutiData[index]['NILAI_INSENTIF'];
                        return GestureDetector(
                          onTap: () {
                            // Tampilkan alert ketika diklik
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Detail Absen:'),
                                  content: Column(
                                    children: [
                                      cutiData[index]['KETERANGAN'] == 'Libur'?
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Image.asset(
                                        'assets/img/holiday.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ],
                                  ):
                                        //in
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 20),
                                            if (cutiData[index]['FOTO_IN'] != null) // Periksa apakah ada URL gambar
                                              Image.network(
                                                fotoIn,
                                                height: 200, // Sesuaikan ukuran gambar sesuai kebutuhan Anda
                                                width: 200,
                                                fit: BoxFit.cover,
                                              ),
                                          ],
                                        ),
                                        cutiData[index]['FOTO_IN'] != null?
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text('Jarak Masuk: $jarakIn'),
                                            Text('Jam Masuk: $jamIn'),
                                            Text('Status Masuk: $statusAbsenIn'),
                                            Text('Jarak Pulang: $jarakOut'),
                                          ],
                                        ) : cutiData[index]['KETERANGAN'] == 'Masuk' || cutiData[index]['KETERANGAN'] == 'Tidak Absen' ?
                                        const Text("Anda belum absen masuk!"): const Text(""),
                                        //out
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 20),
                                            if (cutiData[index]['FOTO_OUT'] != null) // Periksa apakah ada URL gambar
                                              Image.network(
                                                fotoOut,
                                                height: 200, // Sesuaikan ukuran gambar sesuai kebutuhan Anda
                                                width: 200,
                                                fit: BoxFit.cover,
                                              ),
                                          ],
                                        ),
                                        cutiData[index]['FOTO_OUT'] != null?
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text('Jarak Pulang: $jarakOut'),
                                            Text('Jam Pulang: $jamOut'),
                                            Text('Status Pulang: $statusAbsenOut'),
                                            Text('Uang Kehadiran: $nilaiInsentif'),
                                          ],
                                        ): cutiData[index]['KETERANGAN'] == 'Masuk' || cutiData[index]['KETERANGAN'] == 'Tidak Absen' ?
                                        const Text("Anda belum absen Pulang!"): const Text(""),

                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Tutup dialog
                                      },
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Tanggal: $tanggal'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Keterangan: $keterangan'),
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        );

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bagian 4: Menu dengan Icon dan Text di Bawah
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            // Navigasi ke halaman "DashboardPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DashboardPage(),
              ),
            );
          }
          if (index == 2) {
            // Navigasi ke halaman "DashboardPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DataAbsenPage(),
              ),
            );
          }
          if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotifPage(),
              ),
            );
          }
          if (index == 4) {
            // Navigasi ke halaman "AkunPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AkunPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
