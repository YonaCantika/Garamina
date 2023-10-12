import 'package:flutter/material.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'histori_page.dart';
import 'dataAbsen_page.dart';
import 'izin_page.dart';
import 'cuti_page.dart';
import 'dinas_page.dart';
import 'akun_page.dart';
import 'ulangTahun_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

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
        title: const Text('Dashboard'),
      ),
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian 1: Selamat Datang dengan Background Biru
            WelcomeSection(),
            // Bagian 2: Carousel Slider
            CarouselSection(),
            // Bagian 3: ListView dengan Border Radius di Atas
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(

                children: [
                  // Judul "Karyawan Cuti"
                  const Padding(
                    padding: EdgeInsets.all(16.0),
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
                    child: SizedBox(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        const Icon(Icons.hotel, size: 40, color: Colors.white),
                        title: const Text(
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
                    child: SizedBox(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        const Icon(Icons.mail, size: 40, color: Colors.white),
                        title: const Text(
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
                    child: SizedBox(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        const Icon(Icons.business, size: 40, color: Colors.white),
                        title: const Text(
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
                    child: SizedBox(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        const Icon(Icons.cake, size: 40, color: Colors.white),
                        title: const Text(
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
                    child: SizedBox(
                      height: 90, // Sesuaikan tinggi Card sesuai kebutuhan Anda
                      child: ListTile(
                        leading:
                        const Icon(Icons.wallet, size: 40, color: Colors.white),
                        title: const Text(
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
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoriPage(),
              ),
            );
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DataAbsenPage(),
              ),
            );
          }
          if (index == 4) {
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
