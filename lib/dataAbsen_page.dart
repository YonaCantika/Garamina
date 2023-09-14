import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

import 'histori_page.dart';
import 'absen_page.dart';

class DataAbsenPage extends StatefulWidget {
  @override
  _DataAbsenPageState createState() => _DataAbsenPageState();
}

class _DataAbsenPageState extends State<DataAbsenPage> {
  List<Map<String, dynamic>> cutiData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                'Bagus Untoro',
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
                      'Karyawan Cuti',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //  content
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
            // Navigasi ke halaman "DashboardPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoriPage(),
              ),
            );
          }
          if (index == 2) {
            // Navigasi ke halaman "DashboardPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AbsenPage(),
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
