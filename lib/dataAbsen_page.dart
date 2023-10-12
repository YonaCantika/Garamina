import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_state.dart';
import 'absen_state.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'histori_page.dart';
import 'absen_page.dart';
import 'dashboard_page.dart';
import 'akun_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';

class DataAbsenPage extends StatefulWidget {
  @override
  _DataAbsenPageState createState() => _DataAbsenPageState();
}

class _DataAbsenPageState extends State<DataAbsenPage> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> cutiData = [];
  // StreamController<DateTime> _timeStreamController =
  //     StreamController<DateTime>();

  @override
  void initState() {
    super.initState();

    // Memulai Stream waktu
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   _timeStreamController.sink.add(DateTime.now());
    // });
  }

  @override
  void dispose() {
    // _timeStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final absenState = Provider.of<AbsenState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absen'),
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
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Judul "Data Karyawan"
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Data Karyawan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0), // Padding sebelah kiri
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            const Text(
                              'Nama Karyawan:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.namaUser ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'NIK:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.nik ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Cost Center:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.costCenter ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Lokasi:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.lokasi ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Jarak antara Column dan StreamBuilder

                    ],
                  ),



                  const SizedBox(height: 20),
                  Positioned(
                    bottom: 50,
                    left: 20,
                    right: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final idPeg = authState.idPeg;
                                  if (idPeg != null) {
                                    try {
                                      final responseData =
                                          await sendAbsenRequest(idPeg);

                                      absenState.setAbsenData(
                                        checkStatusPegawai: responseData[
                                            'check_status_pegawai'],
                                        checkStatusSPPD:
                                            responseData['check_status_sppd'],
                                        checkStatusDetasering: responseData[
                                            'check_status_detasering'],
                                        checkStatus:
                                            responseData['check_status'],
                                        checkShiftM:
                                            responseData['check_shift_M'],
                                        koordinat: responseData['koordinat'],
                                        statusCuti: responseData['status_cuti'],
                                        jarakKantor:
                                            responseData['jarak_kantor'],
                                        status: responseData['status'],
                                        msg: responseData['msg'],
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AbsenPage(),
                                        ),
                                      );
                                    } catch (error) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Gagal Melakukan Absen'),
                                            content: const Text(
                                                'Terjadi kesalahan saat melakukan absen. Silakan coba lagi.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    // Handle the case where idPeg is null here, e.g., by showing an error message.
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  primary: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Absen',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DashboardPage(),
              ),
            );
          }
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoriPage(),
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

  Future<Map<String, dynamic>> sendAbsenRequest(String idPeg) async {
    final response = await http.post(
      Uri.parse('https://garamina.com/fintech2/integrasi/android/login/v_absen'),
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {'id_peg': idPeg},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['msg'] == 'Sukses') {
        return responseData;
      } else {
        throw Exception('Gagal melakukan absen');
      }
    } else {
      throw Exception('Gagal melakukan absen');
    }
  }
}
