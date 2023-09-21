import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'absen_state.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'histori_page.dart';
import 'absen_page.dart';
import 'dashboard_page.dart';
import 'akun_page.dart';

class DataAbsenPage extends StatefulWidget {
  @override
  _DataAbsenPageState createState() => _DataAbsenPageState();
}

class _DataAbsenPageState extends State<DataAbsenPage> {
  List<Map<String, dynamic>> cutiData = [];
  StreamController<DateTime> _timeStreamController =
      StreamController<DateTime>();

  @override
  void initState() {
    super.initState();

    // Memulai Stream waktu
    Timer.periodic(Duration(seconds: 1), (timer) {
      _timeStreamController.sink.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timeStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final absenState = Provider.of<AbsenState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Absen'),
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          // Bagian 1: Selamat Datang dengan Background Biru
          Container(
            color: Colors.blue,
            height: 100,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                authState.namaUser ?? '',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Bagian 2: Carousel Slider
          Container(
            height: 150,
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              items: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/img/slider/1.JPG'),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/img/slider/2.JPG'),
                ),
                // Tambahkan item Carousel selanjutnya sesuai kebutuhan
              ],
            ),
          ),
          // Bagian 3: ListView dengan Border Radius di Atas
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Judul "Data Karyawan"
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Data Karyawan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
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
                      SizedBox(height: 12),
                      Text(
                        'NIK:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        authState.nik ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Cost Center:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        authState.costCenter ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      StreamBuilder<DateTime>(
                        stream: _timeStreamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final time =
                                DateFormat('HH:mm:ss').format(snapshot.data!);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12),
                                Text(
                                  'Waktu:',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  time,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                                                Text('Gagal Melakukan Absen'),
                                            content: Text(
                                                'Terjadi kesalahan saat melakukan absen. Silakan coba lagi.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
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
                                  padding: EdgeInsets.all(16),
                                  primary: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
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
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/img/logo.png',
              width: 30,
              height: 30,
            ),
            label: 'Absen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
        onTap: (int index) {
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  Future<Map<String, dynamic>> sendAbsenRequest(String idPeg) async {
    final response = await http.post(
      Uri.parse('https://garamina.com/fintech2/integrasi/android/login/v_absen'),
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
