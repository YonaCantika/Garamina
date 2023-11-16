import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'components/actionComponent.dart';
import 'components/customExpandedContainer.dart';
import 'histori_page.dart';
import 'dataAbsen_page.dart';
import 'notif_page.dart';
import 'akun_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';

class StatusPengajuanIzinPage extends StatefulWidget {
  @override
  _StatusPengajuanIzinPageState createState() => _StatusPengajuanIzinPageState();
}

class _StatusPengajuanIzinPageState extends State<StatusPengajuanIzinPage> {
  int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> pengajuanIzinData = [];
  int count =0;
  bool dataResponse = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromApi(idPeg) async {
    count++;
    final apiUrl = Uri.parse('https://garamina.com/fintech2/integrasi/android/report/myIzin');

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'empId': idPeg.toString()
      },
    );

    if (response.statusCode == 200) {
      loading = false;
      final data = jsonDecode(response.body);
      data.length <= 0 ?
      dataResponse = false: dataResponse = true;
      print(data);
      setState(() {
        pengajuanIzinData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    count < 1 ?
    fetchDataFromApi(authState.idPeg):null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Izin'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildUserGuide(context),
              buildInformationCenter(context),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          // Bagian 1: Selamat Datang dengan Background Biru
          WelcomeSection(),
          // Bagian 2: Carousel Slider
          Container(
            height: 150, // Sesuaikan tinggi carousel sesuai kebutuhan Anda
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio:
                16 / 9, // Sesuaikan dengan rasio aspek yang diinginkan
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3), // Interval otomatis
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              items: [
                // Item Carousel 1 dengan gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                      'assets/img/slider/1.JPG'), // Ganti dengan path gambar Anda
                ),
                // Item Carousel 2 dengan gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                      'assets/img/slider/2.JPG'), // Ganti dengan path gambar Anda
                ),
                // Tambahkan item Carousel selanjutnya sesuai kebutuhan
              ],
            ),
          ),
          // Bagian 3: ListView dengan Border Radius di Atas
          CustomExpandedContainer(
            title: 'Data Pengajuan Izin',
            data: pengajuanIzinData,
            loading: loading,
            dataResponse: dataResponse,
            itemBuilder: (context, index) {
              final nomorIzin = pengajuanIzinData[index]['NOMOR_IZIN'];
              final kategoriIzin = pengajuanIzinData[index]['KATEGORI_IZIN'];
              final tipeIzin = pengajuanIzinData[index]['TIPE_IZIN'];
              final keterangan = pengajuanIzinData[index]['KETERANGAN'];
              final tanggalPengajuan = pengajuanIzinData[index]['TANGGAL_PENGAJUAN'];
              final mulaiIzin = pengajuanIzinData[index]['MULAI_IZIN'];
              final selesaiIzin = pengajuanIzinData[index]['SELESAI_IZIN'];
              final lamaIzin = pengajuanIzinData[index]['LAMA_IZIN'];
              final statusIzin = pengajuanIzinData[index]['STATUS_IZIN'];
              return Column(
                children: [
                  ListTile(
                    title: Text('Kategori: $kategoriIzin'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipe Izin: $tipeIzin'),
                        Text('Keterangan: $keterangan'),
                        Text('Mulai Izin: $mulaiIzin'),
                        Text('Selesai Izin: $selesaiIzin'),
                        Text('Status: $statusIzin'),
                      ],
                    ),
                    trailing: statusIzin == 'Sudah Approval' ?
                    const Icon(Icons.verified, size: 30, color: Colors.green) :
                    statusIzin == 'Belum Approval' ? const Icon(Icons.hourglass_top, size: 30, color: Colors.orange) :
                    const Icon(Icons.rate_review, size: 30, color: Colors.red),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ],
      ),
      // Bagian 4: Menu dengan Icon dan Text di Bawah
      // bottomNavigationBar: BottomMenu(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: (int index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //     if (index == 1) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => HistoriPage(),
      //         ),
      //       );
      //     }
      //     if (index == 2) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => DataAbsenPage(),
      //         ),
      //       );
      //     }
      //     if (index == 3) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => NotifPage(),
      //         ),
      //       );
      //     }
      //     if (index == 4) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => AkunPage(),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
