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

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
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
        title: Text('Akun'),
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
                'Profil Karyawan',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Bagian 2: Circle Avatar dengan sedikit spasi di bawahnya
          Container(
            height: 150, // Sesuaikan tinggi Circle Avatar sesuai kebutuhan Anda
            child: Column(
              children: [
                CircleAvatar(
                  radius:
                      75, // Sesuaikan radius lingkaran sesuai kebutuhan Anda
                  backgroundColor:
                      Colors.blue, // Warna latar belakang lingkaran
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img/slider/1.JPG', // Ganti dengan path gambar Anda
                      width:
                          150, // Sesuaikan lebar gambar sesuai kebutuhan Anda
                      height:
                          150, // Sesuaikan tinggi gambar sesuai kebutuhan Anda
                      fit: BoxFit
                          .cover, // Sesuaikan tampilan gambar sesuai kebutuhan Anda
                    ),
                  ),
                ), // Tambahkan spasi di bawah CircleAvatar
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0), // Padding sebelah kiri
                        child: Column(
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
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
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
            // Navigasi ke halaman "AkunPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoriPage(),
              ),
            );
          }
          if (index == 2) {
            // Navigasi ke halaman "AkunPage"
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DataAbsenPage(),
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
