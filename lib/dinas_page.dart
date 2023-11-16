import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'components/actionComponent.dart';
import 'histori_page.dart';
import 'dataAbsen_page.dart';
import 'notif_page.dart';
import 'akun_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';
import 'components/customExpandedContainer.dart';

class DinasPage extends StatefulWidget {
  @override
  _DinasPageState createState() => _DinasPageState();
}

class _DinasPageState extends State<DinasPage> {
  int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> dinasData = [];
  bool dataResponseDinas = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final apiUrl = Uri.parse('https://garamina.com/fintech2/integrasi/android/report/dinas');
    // final now = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'mulaiDinas': '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        'selesaiDinas': '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      },
    );

    if (response.statusCode == 200) {
      loading = false;
      final data = jsonDecode(response.body);
      // print(data);
      data.length <= 0 ?
      dataResponseDinas = false: dataResponseDinas = true;
      setState(() {
        dinasData = List<Map<String, dynamic>>.from(data);
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
        title: const Text('Dinas'),
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
          CarouselSection(),
          // Bagian 3: ListView dengan Border Radius di Atas
          CustomExpandedContainer(
            title: 'Karyawan Dinas',
            data: dinasData,
            loading: loading,
            dataResponse: dataResponseDinas,
            itemBuilder: (context, index) {
              final namaPegawai = dinasData[index]['NAMA_PEGAWAI'];
              final periode = dinasData[index]['PERIODE'];
              final tujuan = dinasData[index]['TUJUAN'];

              return Column(
                children: [
                  ListTile(
                    title: Text('Nama: $namaPegawai'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tujuan: $tujuan'),
                        Text('Periode: $periode'),
                      ],
                    ),
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
      //       // Navigasi ke halaman "DinasPage"
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => HistoriPage(),
      //         ),
      //       );
      //     }
      //     if (index == 2) {
      //       // Navigasi ke halaman "DinasPage"
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
      //       // Navigasi ke halaman "AkunPage"
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
