import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:garamina/jadwal_page.dart';
import 'package:garamina/statusPengajuanCuti_Page.dart';
import 'package:garamina/statusPengajuanIzin_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dinas_page.dart';
import 'components/actionComponent.dart';
import 'components/easy_access.dart';

class HRPage extends StatefulWidget {
  @override
  _HRPageState createState() => _HRPageState();
}

class _HRPageState extends State<HRPage> {
  DateTime dateTime = DateTime.now();
  int tabIndex = 0;

  List<Map<String, dynamic>> izinData = [];
  bool loadingIzin = true;
  bool dataResponseIzin = false;
  int _currentIndexIzin = 0;

  List<Map<String, dynamic>> dinasData = [];
  bool loadingDinas = true;
  bool dataResponseDinas = false;
  int _currentIndexDinas = 0;

  List<Map<String, dynamic>> cutiData = [];
  bool loadingCuti = true;
  bool dataResponseCuti = false;
  int _currentIndexCuti = 0;

  @override
  void initState() {
    super.initState();
    fetchDataCuti();
    fetchDataIzin();
    fetchDataDinas();
  }

  Future<void> fetchDataCuti() async {
    final apiUrl = Uri.parse(
        'https://garamina.com/fintech2/integrasi/android/report/cuti');

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'mulaiCuti':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        'selesaiCuti':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      },
    );

    if (response.statusCode == 200) {
      loadingCuti = false;
      final data = jsonDecode(response.body);
      data.length <= 0 ? dataResponseCuti = false : dataResponseCuti = true;
      setState(() {
        cutiData = List<Map<String, dynamic>>.from(data);
      });
      print(cutiData);
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataIzin() async {
    final apiUrl = Uri.parse(
        'https://garamina.com/fintech2/integrasi/android/report/izin');
    // 'http://192.168.1.252/fintech2/integrasi/android/report/izin');

    // final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        // 'mulaiIzin': '2023-10-17',
        // 'selesaiIzin': '2023-10-17',
        'mulaiIzin':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        'selesaiIzin':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      },
    );

    if (response.statusCode == 200) {
      loadingIzin = false;
      final data = jsonDecode(response.body);
      print('izin $data');
      data.length <= 0 ? dataResponseIzin = false : dataResponseIzin = true;
      setState(() {
        izinData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataDinas() async {
    final apiUrl = Uri.parse(
        'https://garamina.com/fintech2/integrasi/android/report/dinas');
    // 'http://192.168.1.252/fintech2/integrasi/android/report/dinas');

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        // 'mulaiDinas': '2023-11-27',
        // 'selesaiDinas': '2023-11-27',
        'mulaiDinas':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        'selesaiDinas':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      },
    );

    if (response.statusCode == 200) {
      loadingDinas = false;
      final data = jsonDecode(response.body);
      print('Dinas: $data');
      data.length <= 0 ? dataResponseDinas = false : dataResponseDinas = true;
      setState(() {
        dinasData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Human Resource'),
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian 1: card data
            Image.asset(
              'assets/img/dashboard/employee.png',
              height: 200,
            ),
            const SizedBox(
              height: 8,
            ),
            // Bagian 3:
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // menu
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // Warna latar belakang
                        borderRadius: const BorderRadius.only(
                          // bottomLeft: Radius.circular(10),
                          // bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, -2),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Cuti
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StatusPengajuanCutiPage(),
                                    ),
                                  );
                                },
                                child: EasyAccess(
                                    path: 'assets/img/menu/cuti.png',
                                    color: Colors.red,
                                    text: 'CUTI'),
                              ),
                              // Izin
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StatusPengajuanIzinPage(),
                                    ),
                                  );
                                },
                                child: EasyAccess(
                                    path: 'assets/img/menu/mail.png',
                                    color: Colors.orange,
                                    text: 'IZIN'),
                              ),
                              // Dinas
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DinasPage(),
                                    ),
                                  );
                                },
                                child: EasyAccess(
                                    path: 'assets/img/menu/dinas.png',
                                    color: Colors.green,
                                    text: 'DINAS'),
                              ),
                              // Koperasi
                              EasyAccess(
                                  path: 'assets/img/menu/koperasi.png',
                                  color: Colors.purple,
                                  text: 'KOPERASI'),
                              // Jadwal
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JadwalPage(),
                                    ),
                                  );
                                },
                                child: EasyAccess(
                                    path: 'assets/img/menu/jadwal.png',
                                    color: Colors.teal,
                                    text: 'JADWAL'),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          tabIndex = 0;
                                        });
                                      },
                                      child: Text(
                                        tabIndex == 0
                                            ? 'Karyawan Cuti'
                                            : 'Lihat Cuti',
                                        style: TextStyle(
                                            fontSize: tabIndex == 0 ? 17 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: tabIndex == 0
                                                ? Colors.black
                                                : Colors.grey),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          tabIndex = 1;
                                        });
                                      },
                                      child: Text(
                                        tabIndex == 1
                                            ? 'Karyawan Izin'
                                            : 'Lihat Izin',
                                        style: TextStyle(
                                            fontSize: tabIndex == 1 ? 17 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: tabIndex == 1
                                                ? Colors.black
                                                : Colors.grey),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          tabIndex = 2;
                                        });
                                      },
                                      child: Text(
                                        tabIndex == 2
                                            ? 'Karyawan Dinas'
                                            : 'Lihat Dinas',
                                        style: TextStyle(
                                            fontSize: tabIndex == 2 ? 17 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: tabIndex == 2
                                                ? Colors.black
                                                : Colors.grey),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // bagian 1
                              tabIndex == 0
                                  ? cutiData.isEmpty
                                      ? const Center(
                                          child: Text('Belum ada data cuti'),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: cutiData.length,
                                          itemBuilder: (context, index) {
                                            // final foto = dinasData[index]['foto'];
                                            const foto =
                                                'https://garamina.com/hr/files/emp/pic/pic_20190624_213733_798.jpeg';
                                            return Column(
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        FileImage(File(foto)),
                                                  ),
                                                  title: Text(
                                                      '${cutiData[index]['NAMA_PEGAWAI']}'),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${cutiData[index]['NAMA_CUTI']}'),
                                                      Text(
                                                          'Pengganti: ${cutiData[index]['PENGGANTI']}'),
                                                    ],
                                                  ),
                                                  trailing: Text(
                                                      '${cutiData[index]['PERIODE']}'),
                                                ),
                                                const Divider(),
                                              ],
                                            );
                                          },
                                        )
                                  : tabIndex == 1
                                      ? izinData.isEmpty
                                          ? const Center(
                                              child:
                                                  Text('Belum ada data izin'),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: izinData.length,
                                              itemBuilder: (context, index) {
                                                // final foto = dinasData[index]['foto'];
                                                final foto =
                                                    'https://garamina.com/hr/files/emp/pic/pic_20190624_213733_798.jpeg';
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            FileImage(
                                                                File(foto)),
                                                      ),
                                                      title: Text(
                                                          '${izinData[index]['NAMA_PEGAWAI']}'),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              '${izinData[index]['NAMA_IZIN']}'),
                                                          Text(
                                                              'Pengganti: ${izinData[index]['PENGGANTI']}'),
                                                        ],
                                                      ),
                                                      trailing: Text(
                                                          '${izinData[index]['PERIODE']}'),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              },
                                            )
                                      : tabIndex == 2
                                          ?
                                          // bagian 3

                                          dinasData.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                      'Belum ada data dinas'),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: dinasData.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    const foto =
                                                        'https://garamina.com/hr/files/emp/pic/pic_20190624_213733_798.jpeg';
                                                    return Column(
                                                      children: [
                                                        ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundImage:
                                                                FileImage(
                                                                    File(foto)),
                                                          ),
                                                          title: Text(
                                                              '${dinasData[index]['NAMA_PEGAWAI']}'),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '${dinasData[index]['TUJUAN']}'),
                                                            ],
                                                          ),
                                                          trailing: Text(
                                                              '${dinasData[index]['PERIODE']}'),
                                                        ),
                                                        const Divider(),
                                                      ],
                                                    );
                                                  },
                                                )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
