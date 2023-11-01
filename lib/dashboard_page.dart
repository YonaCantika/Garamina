import 'package:flutter/material.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'histori_page.dart';
import 'dataAbsen_page.dart';
import 'izin_page.dart';
import 'cuti_page.dart';
import 'dinas_page.dart';
import 'akun_page.dart';
import 'notif_page.dart';
import 'ulangTahun_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';
import 'components/form_cuti.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<String> tipeCutiOptions = ['Pilihan 1', 'Pilihan 2', 'Pilihan 3'];
  String selectedTipeCuti = 'Pilihan 1';

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
        automaticallyImplyLeading: false,
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
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Card vertikal (cuti, izin, dinas)
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
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Lihat Data Cuti'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CutiPage(),
                                          ),
                                        );
                                      },

                                    ),
                              ListTile(
                                title: Text('Pengajuan Cuti'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return FormCuti(); // Panggil FormCuti di sini
                                      },
                                    );
                                  },
                              ),

                              ],
                                ),
                              );
                            },
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
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Lihat Data Izin'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => IzinPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Pengajuan Izin'),
                                      onTap: () {
                                        Navigator.of(context).pop(); // Tutup bottom sheet

                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.8, // Sesuaikan faktor tinggi modal
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Pengajuan Izin',
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                      ),
                                                      TextFormField(
                                                        decoration: InputDecoration(labelText: 'Keterangan'),
                                                        // Tambahkan controller untuk mengambil nilai input
                                                      ),
                                                      TextFormField(
                                                        decoration: InputDecoration(labelText: 'Periode (tanggal)'),
                                                        // Tambahkan controller untuk mengambil nilai input
                                                      ),
                                                      TextFormField(
                                                        decoration: InputDecoration(labelText: 'Pengganti'),
                                                        // Tambahkan controller untuk mengambil nilai input
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Tambahkan kode untuk mengirim data pengajuan cuti
                                                          // Misalnya, kirim data ke server atau penyimpanan lokal
                                                          // Kemudian tutup modal input
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Ajukan Izin'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },

                                    ),
                                  ],
                                ),
                              );
                            },
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
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Lihat Data Dinas'),
                                      onTap: () {
                                        Navigator.of(context).pop();

                                        // Navigasi ke halaman terkait (DinasPage)
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DinasPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Pengajuan Dinas'),
                                      onTap: () {
                                        Navigator.of(context).pop(); // Tutup bottom sheet

                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.8, // Sesuaikan faktor tinggi modal
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Pengajuan Dinas',
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                      ),
                                                      TextFormField(
                                                        decoration: InputDecoration(labelText: 'Keterangan'),
                                                        // Tambahkan controller untuk mengambil nilai input
                                                      ),
                                                      TextFormField(
                                                        decoration: InputDecoration(labelText: 'Periode (tanggal)'),
                                                        // Tambahkan controller untuk mengambil nilai input
                                                      ),
                                                      TextFormField(
                                                        decoration: InputDecoration(labelText: 'Pengganti'),
                                                        // Tambahkan controller untuk mengambil nilai input
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Tambahkan kode untuk mengirim data pengajuan cuti
                                                          // Misalnya, kirim data ke server atau penyimpanan lokal
                                                          // Kemudian tutup modal input
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Ajukan Dinas'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },

                                    ),
                                  ],
                                ),
                              );
                            },
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
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Lihat Data Ulang Tahun'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UlangTahunPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Menu lainnya'),
                                      onTap: () {
                                        // Tindakan yang diambil saat "Input" dipilih
                                        Navigator.of(context).pop(); // Tutup bottom sheet
                                        // Tambahkan kode untuk input data
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Lihat Data Gaji'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UlangTahunPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Menu Lainnya'),
                                      onTap: () {
                                        // Tindakan yang diambil saat "Input" dipilih
                                        Navigator.of(context).pop(); // Tutup bottom sheet
                                        // Tambahkan kode untuk input data
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
          if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotifPage(),
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
