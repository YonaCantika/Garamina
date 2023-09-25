import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'histori_page.dart';
import 'absen_page.dart';
import 'dataAbsen_page.dart';
import 'izin_page.dart';
import 'cuti_page.dart';
import 'dinas_page.dart';
import 'akun_page.dart';
import 'ulangTahun_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> cutiData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Judul "Karyawan Cuti"
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Tiga Card vertikal (cuti, izin, dinas)
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.blue, // Warna latar belakang biru untuk Card
                    child: Container(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        Icon(Icons.hotel, size: 40, color: Colors.white),
                        title: Text(
                          'Karyawan Cuti',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onTap: () {
                          // Navigasi ke halaman terkait (CutiPage)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CutiPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.blue, // Warna latar belakang biru untuk Card
                    child: Container(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        Icon(Icons.mail, size: 40, color: Colors.white),
                        title: Text(
                          'Karyawan Izin',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onTap: () {
                          // Navigasi ke halaman terkait (IzinPage)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => IzinPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.blue, // Warna latar belakang biru untuk Card
                    child: Container(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        Icon(Icons.business, size: 40, color: Colors.white),
                        title: Text(
                          'Karyawan Dinas',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onTap: () {
                          // Navigasi ke halaman terkait (DinasPage)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DinasPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.blue, // Warna latar belakang biru untuk Card
                    child: Container(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        Icon(Icons.cake, size: 40, color: Colors.white),
                        title: Text(
                          'Karyawan Ulang Tahun',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onTap: () {
                          // Navigasi ke halaman terkait (DinasPage)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UlangTahunPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.blue, // Warna latar belakang biru untuk Card
                    child: Container(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        Icon(Icons.wallet, size: 40, color: Colors.white),
                        title: Text(
                          'Gaji',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onTap: () {
                          // Navigasi ke halaman terkait (DinasPage)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UlangTahunPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            // Navigasi ke halaman "Histori Page"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoriPage(),
              ),
            );
          }
          if (index == 2) {
            // Navigasi ke halaman "Ada Absen"
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
