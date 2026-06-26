import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garamina/dinas_page.dart';
import 'package:garamina/jadwal_page.dart';
import 'package:garamina/statusPengajuanCuti_Page.dart';
import 'package:garamina/statusPengajuanIzin_page.dart';
import 'package:garamina/survei_page.dart';
import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'components/actionComponent.dart';
import 'components/easy_access.dart';
import 'package:intl/intl.dart';
import 'package:garamina/services/api_services.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int count = 0;
  DateTime dateTime = DateTime.now();
  int tabIndex = 0;
  bool show = false;
  String? saldo;
  final currencyFormatter = NumberFormat.currency(locale: 'ID');

  List<Map<String, dynamic>> ultahData = [];
  bool dataResponseUltah = false;
  bool loadingUltah = true;
  int _currentIndex = 0;

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
    fetchDataUltah();
    fetchDataCuti();
    fetchDataIzin();
    fetchDataDinas();
  }

  String formatRupiah(double saldo) {
    final formatCurrency = NumberFormat.currency(locale: 'id', symbol: 'Rp');
    return formatCurrency.format(saldo);
  }

  Future<void> fetchDataUltah() async {
    final apiUrl = Uri.parse(
        ApiServices.reportUlangTahun);
    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {
        'tanggal':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        // '2021-03-07',
      },
    );

    if (response.statusCode == 200) {
      loadingUltah = false;
      final data = jsonDecode(response.body);
      print('Ultah: $data');
      data.length <= 0 ? dataResponseUltah = false : dataResponseUltah = true;
      setState(() {
        ultahData = List<Map<String, dynamic>>.from(data);
      });
      print(ultahData);
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Widget buildCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: ultahData.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.yellow],
                      stops: [0.9, 0.0],
                    ),
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
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          item['FOTO'] != 'default.png'
                              ? Image.network(
                                  item['FOTO'].toString(),
                                  width: 50,
                                )
                              : const SizedBox(width: 50),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                Text(
                                  '${item['NAMA_PEGAWAI']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${item['TANGGAL']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${item['USIA']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 100.0,
            enlargeCenterPage: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ultahData.map((item) {
            int index = ultahData.indexOf(item);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _currentIndex ? Colors.blueAccent : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> fetchDataCuti() async {
    final apiUrl = Uri.parse(
        ApiServices.reportCuti);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
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
        ApiServices.reportIzin);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {
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
        ApiServices.reportDinas);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {
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

  Future<void> fetchDataSaldo(nik) async {
    setState(() {
      count++;
    });
    final apiUrl = Uri.parse(
        ApiServices.reportSaldoKoperasi);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {'nik': nik.toString()},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data[0]['SALDO'] != null || data[0]['SALDO'] != 'null') {
        setState(() {
          saldo = data[0]['SALDO'];
        });
      } else {
        setState(() {
          saldo = '0';
        });
      }
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    count < 1 ? fetchDataSaldo(authState.nik) : null;
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
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [Colors.blue, Colors.yellow],
                  stops: [0.9, 0.0],
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
              child: Column(children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Selamat ${dateTime.hour >= 01 && dateTime.hour <= 09 ? 'Pagi' : dateTime.hour > 09 && dateTime.hour < 15 ? 'Siang' : dateTime.hour >= 15 && dateTime.hour <= 19 ? 'Sore' : 'Malam'}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          authState.namaUser ?? '',
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          authState.costCenter ?? 'Cost Center',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Kerja Kita Prestasi Bersama!',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ]),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SurveiPage(),
                                    ),
                                  );
                                },
                                child: EasyAccess(
                                    path: 'assets/img/menu/survey.png',
                                    color: Colors.blue,
                                    text: 'SURVEI'),
                              ),
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
                          const SizedBox(height: 16.0),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     InkWell(
                          //       onTap: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => SurveiPage(),
                          //           ),
                          //         );
                          //       },
                          //       child: EasyAccess(
                          //           path: 'assets/img/menu/survey.png',
                          //           color: Colors.blue,
                          //           text: 'SURVEI'),
                          //     ),
                          //     EasyAccess(
                          //         path: 'assets/img/menu/emeeting.png',
                          //         color: Colors.purple,
                          //         text: 'E-MEETING'),
                          //     EasyAccess(
                          //         path: 'assets/img/menu/penilaian.png',
                          //         color: Colors.teal,
                          //         text: 'PENILAIAN 360'),
                          //     EasyAccess(
                          //         path: 'assets/img/menu/spt.png',
                          //         color: Colors.indigo,
                          //         text: 'SPT'),
                          //     InkWell(
                          //       onTap: () {
                          //         showModalBottomSheet(
                          //           context: context,
                          //           isScrollControlled: true,
                          //           builder: (BuildContext context) {
                          //             return FractionallySizedBox(
                          //               heightFactor: 0.3,
                          //               child: SingleChildScrollView(
                          //                 child: Container(
                          //                   padding: const EdgeInsets.all(16),
                          //                   child: Column(
                          //                     mainAxisSize: MainAxisSize.min,
                          //                     children: [
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment
                          //                                 .spaceAround,
                          //                         children: [
                          //                           EasyAccess(
                          //                               path:
                          //                                   'assets/img/menu/mrp.png',
                          //                               color: Colors.blue,
                          //                               text: 'MRP'),
                          //                           EasyAccess(
                          //                               path:
                          //                                   'assets/img/menu/reminder.png',
                          //                               color: Colors.green,
                          //                               text: 'Reminder'),
                          //                           EasyAccess(
                          //                               path:
                          //                                   'assets/img/menu/bankgaransi.png',
                          //                               color: Colors.orange,
                          //                               text: 'BANK GARANSI'),
                          //                           EasyAccess(
                          //                               path:
                          //                                   'assets/img/menu/docerp.png',
                          //                               color: Colors.yellow,
                          //                               text: 'FINANCE'),
                          //                           EasyAccess(
                          //                               path:
                          //                                   'assets/img/menu/visitor.png',
                          //                               color: Colors.yellow,
                          //                               text: 'ACCOUNTING'),
                          //                         ],
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       },
                          //       child: EasyAccess(
                          //           path: 'assets/img/menu/other.png',
                          //           color: Colors.lightBlue.shade300,
                          //           text: 'LAINNYA'),
                          //     ),
                          //   ],
                          // ),
                        ],
                      )),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            show = !show;
                          });
                        },
                        child: Text(
                          'Saldo Koperasi : ${show ? formatRupiah(double.parse(saldo ?? '0')) : 'Rp. xxx-xxx-xxx'} ',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Karyawan Ulang Tahun',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  loadingUltah
                      ? const Center(child: CircularProgressIndicator())
                      : dataResponseUltah
                          ? buildCarousel()
                          : const Center(
                              child: Text(
                              'Tidak ada yang berulang tahun hari ini',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.orange),
                            )),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Undangan E-Meeting',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  const Text(
                    'Will be develop',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.orange),
                  ),
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
                            tabIndex == 0
                                ? Expanded(
                                    child: loadingCuti
                                        ? const Center(
                                            child: Text('Loading...'),
                                          )
                                        : cutiData.isEmpty
                                            ? const Center(
                                                child:
                                                    Text('Belum ada yang cuti'),
                                              )
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: cutiData.length,
                                                itemBuilder: (context, index) {
                                                  const foto =
                                                      ApiServices.defaultProfilePic;
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              FileImage(
                                                                  File(foto)),
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
                                                      Divider(),
                                                    ],
                                                  );
                                                },
                                              ),
                                  )
                                : tabIndex == 1
                                    ? Expanded(
                                        child: loadingIzin
                                            ? const Center(
                                                child: Text('Loading...'),
                                              )
                                            : izinData.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                        'Belum ada yang izin'),
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: izinData.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      const foto =
                                                          ApiServices.defaultProfilePic;
                                                      return Column(
                                                        children: [
                                                          ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  FileImage(File(
                                                                      foto)),
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
                                                          Divider(),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                      )
                                    : tabIndex == 2
                                        ?
                                        // bagian 3
                                        Expanded(
                                            child: loadingDinas
                                                ? const Center(
                                                    child: Text('Loading...'),
                                                  )
                                                : dinasData.isEmpty
                                                    ? const Center(
                                                        child: Text(
                                                            'Belum ada yang dinas'),
                                                      )
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            dinasData.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          const foto =
                                                              ApiServices.defaultProfilePic;
                                                          return Column(
                                                            children: [
                                                              ListTile(
                                                                leading:
                                                                    CircleAvatar(
                                                                  backgroundImage:
                                                                      FileImage(
                                                                          File(
                                                                              foto)),
                                                                ),
                                                                title: Text(
                                                                    '${dinasData[index]['NAMA_PEGAWAI']}'),
                                                                subtitle:
                                                                    Column(
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
                                                              Divider(),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                          )

                                        // dinasData.isEmpty
                                        //     ? const Center(
                                        //         child: Text(
                                        //             'Belum ada data dinas'),
                                        //       )
                                        //     : ListView.builder(
                                        //         shrinkWrap: true,
                                        //         itemCount: dinasData.length,
                                        //         itemBuilder: (context, index) {
                                        //           const foto =
                                        //               ApiServices.defaultProfilePic;
                                        //           return Column(
                                        //             children: [
                                        //               ListTile(
                                        //                 leading: CircleAvatar(
                                        //                   backgroundImage:
                                        //                       FileImage(
                                        //                           File(foto)),
                                        //                 ),
                                        //                 title: Text(
                                        //                     '${dinasData[index]['NAMA_PEGAWAI']}'),
                                        //                 subtitle: Column(
                                        //                   crossAxisAlignment:
                                        //                       CrossAxisAlignment
                                        //                           .start,
                                        //                   children: [
                                        //                     Text(
                                        //                         '${dinasData[index]['TUJUAN']}'),
                                        //                   ],
                                        //                 ),
                                        //                 trailing: Text(
                                        //                     '${dinasData[index]['PERIODE']}'),
                                        //               ),
                                        //               const Divider(),
                                        //             ],
                                        //           );
                                        //         },
                                        //       )
                                        : const SizedBox(
                                            height: 0,
                                          ),
                          ],
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
