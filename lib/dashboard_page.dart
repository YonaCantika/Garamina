import 'package:flutter/material.dart';
import 'package:garamina/statusPengajuanCuti_Page.dart';
import 'package:garamina/statusPengajuanIzin_page.dart';
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
import 'components/form_izin.dart';
import 'components/customCard.dart';
import 'components/actionComponent.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<String> tipeCutiOptions = ['Pilihan 1', 'Pilihan 2', 'Pilihan 3'];
  String selectedTipeCuti = 'Pilihan 1';
  DateTime dateTime = DateTime.now();

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
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildUserGuide(context),
              buildInformationCenter(context),
            ],
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian 1: Selamat Datang dengan Background Biru
            // WelcomeSection(),
            // Bagian 2: Carousel Slider
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [Colors.blue, Colors.yellowAccent],
                  stops: [0.9, 0.0], // 30% dari sudut
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
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
                    const SizedBox(height: 25,),
                    Text('Selamat ${dateTime.hour >= 01 && dateTime.hour <= 09 ? 'Pagi': dateTime.hour > 09 && dateTime.hour < 15 ? 'Siang' : dateTime.hour >= 15 && dateTime.hour <= 19 ? 'Sore' : 'Malam'}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),),
                    const SizedBox(height: 10,),
                    SizedBox(
                      height: 100,
                      width: double
                          .infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              authState.namaUser??'',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 3,),
                            Text(
                              authState.costCenter??'Cost Center',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 25,),
                            const Text('Kerja Kita Prestasi Bersama!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ]
                      ),
                    ),
                  ]
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // CarouselSection(),
            // Bagian 3: ListView dengan Border Radius di Atas
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: const Offset(0, 3),
                //   ),
                // ],
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
                  // cuti
                  CustomCard(
                    icon: Icons.hotel,
                    title: 'Karyawan Cuti',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: const Text('Data Karyawan Cuti'),
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
                                ListTile(
                                  title: const Text('Status Pengajuan Cuti'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StatusPengajuanCutiPage(),
                                      ),
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
                  // izin
                  CustomCard(
                    icon: Icons.mail,
                    title: 'Karyawan Izin',
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
                                        return FormIzin(); // Panggil FormCuti di sini
                                      },
                                    );
                                  },

                                ),
                                ListTile(
                                  title: Text('Status Pengajuan Izin'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StatusPengajuanIzinPage(),
                                      ),
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
                  // dinas
                  CustomCard(
                    icon: Icons.mail,
                    title: 'Karyawan Dinas',
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
                                                  const Text(
                                                    'Pengajuan Dinas',
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  Image.asset(
                                                    'assets/img/dashboard/develop.png',
                                                    width: 300,
                                                    height: 300,
                                                  ),
                                                  const Text(
                                                    'Next Develop...',
                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
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
                  // ultah
                  CustomCard(
                    icon: Icons.mail,
                    title: 'Ulang Tahun',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: const Text('Lihat Ulang Tahun'),
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
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // gaji
                  CustomCard(
                    icon: Icons.mail,
                    title: 'Gaji',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: const Text('Lihat Gaji'),
                                  onTap: () {
                                    Navigator.of(context).pop();
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
                                                  const Text(
                                                    'Lihat Gaji',
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  Image.asset(
                                                    'assets/img/dashboard/gaji.png',
                                                    width: 300,
                                                    height: 300,
                                                  ),
                                                  const Text(
                                                    'Gaji is privacy data...',
                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
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
                                ListTile(
                                  title: const Text('Berbagi Kebahagiaan'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.8, // faktor ketinggian modal
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Berbagi Kebahagiaan',
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  Image.asset(
                                                    'assets/img/dashboard/employee.png',
                                                    width: 300,
                                                    height: 300,
                                                  ),
                                                  // const Text(
                                                  //   'Agar Aplikasi lebih runtut',
                                                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                                                  // ),
                                                  // const Text(
                                                  //   'Boleh dong saya direkrut',
                                                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                                                  // ),
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
