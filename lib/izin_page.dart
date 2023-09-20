import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'histori_page.dart';
import 'akun_page.dart';
import 'dataAbsen_page.dart';

class IzinPage extends StatefulWidget {
  @override
  _IzinPageState createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  List<Map<String, dynamic>> cutiData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final apiUrl = Uri.parse('http://localhost:8000/api/izin');
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.post(
      apiUrl,
      body: {
        'mulaiIzin': formattedDate,
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
        title: Text('Izin'),
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
                      'img/slider/1.JPG'), // Ganti dengan path gambar Anda
                ),
                // Item Carousel 2 dengan gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                      'img/slider/2.JPG'), // Ganti dengan path gambar Anda
                ),
                // Tambahkan item Carousel selanjutnya sesuai kebutuhan
              ],
            ),
          ),
          // Bagian 3: ListView dengan Border Radius di Atas
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Judul "Karyawan Cuti"
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Karyawan Izin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Daftar data ListView
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cutiData.length,
                      itemBuilder: (context, index) {
                        final namaPegawai = cutiData[index]['NAMA_PEGAWAI'];
                        final periode = cutiData[index]['PERIODE'];
                        final keterangan = cutiData[index]['KETERANGAN'];
                        final pengganti = cutiData[index]['PENGGANTI'];
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Nama: $namaPegawai'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Keterangan: $keterangan'),
                                  Text('Pengganti: $pengganti'),
                                  Text('Periode: $periode'),
                                ],
                              ),
                              // trailing: Icon(Icons.arrow_forward),
                            ),
                            Divider(),
                          ],
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
              'img/logo.png',
              width: 30, // Sesuaikan lebar gambar
              height: 30, // Sesuaikan tinggi gambar
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
          if (index == 1) {
            // Navigasi ke halaman "IzinPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoriPage(),
              ),
            );
          }
          if (index == 2) {
            // Navigasi ke halaman "IzinPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DataAbsenPage(),
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
        selectedItemColor: Colors.black, // Warna item yang dipilih
        unselectedItemColor: Colors.black, // Warna item yang tidak dipilih
      ),
    );
  }
}
