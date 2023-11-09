import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'components/actionComponent.dart';
import 'components/customExpandedContainer.dart';
import 'histori_page.dart';
import 'notif_page.dart';
import 'akun_page.dart';
import 'dataAbsen_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';

class UlangTahunPage extends StatefulWidget {
  @override
  _UlangTahunPageState createState() => _UlangTahunPageState();
}

class _UlangTahunPageState extends State<UlangTahunPage> {
  int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> ultahData = [];
  bool dataResponse = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final apiUrl = Uri.parse('https://garamina.com/fintech2/integrasi/android/report/ulang_tahun');
    // final now = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'tanggal': '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      },
    );

    if (response.statusCode == 200) {
      loading = false;
      final data = jsonDecode(response.body);
      print(data);
      data.length <= 0 ?
      dataResponse = false: dataResponse = true;
      setState(() {
        ultahData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulang Tahun'),
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
            title: 'Karyawan Ulang Tahun',
            data: ultahData,
            loading: loading,
            dataResponse: dataResponse,
            itemBuilder: (context, index) {
              final namaPegawai = ultahData[index]['NAMA_PEGAWAI'];
              final tanggal = ultahData[index]['TANGGAL'];
              final usia = ultahData[index]['USIA'];
              return Column(
                children: [
                  ListTile(
                    title: Text('Nama: $namaPegawai'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: $tanggal'),
                        Text('Usia: $usia'),
                      ],
                    ),
                    trailing:InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                              heightFactor: 0.8,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Berikan Ucapan',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        decoration: const InputDecoration(labelText: 'Pesan'),
                                        // controller: keteranganCutiController,
                                      ),
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(16),
                                            primary: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text('Kirim Pesan'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const SizedBox(
                        height: 50,
                        width: 50, // Lebar ikon kedua
                        child: Icon(Icons.message_rounded, size: 30, color: Colors.black),
                      ),
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
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            // Navigasi ke halaman "UlangTahunPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoriPage(),
              ),
            );
          }
          if (index == 2) {
            // Navigasi ke halaman "UlangTahunPage"
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
