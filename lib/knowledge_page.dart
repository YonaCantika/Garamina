import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:garamina/statusPengajuanCuti_Page.dart';
import 'package:garamina/statusPengajuanIzin_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dinas_page.dart';
import 'components/actionComponent.dart';
import 'components/easy_access.dart';
import 'package:garamina/services/api_services.dart';

class KnowledgePage extends StatefulWidget {
  @override
  _KnowledgePageState createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  DateTime dateTime = DateTime.now();
  int _currentIndex = 0;

  List<Map<String, dynamic>> izinData = [];
  bool loadingIzin = true;
  bool dataResponseIzin = false;

  List<Map<String, dynamic>> dinasData = [];
  bool loadingDinas = true;
  bool dataResponseDinas = false;

  List<Map<String, dynamic>> cutiData = [];
  bool loadingCuti = true;
  bool dataResponseCuti = false;

  @override
  void initState() {
    super.initState();
    fetchDataCuti();
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

  Widget buildCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: cutiData.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
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
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${item['NAMA_PEGAWAI']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${item['NAMA_CUTI']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${item['PERIODE']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Pengganti ${item['PENGGANTI']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
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
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cutiData.asMap().entries.map((entry) {
            int index = entry.key;
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _currentIndex ? Colors.orange : Colors.white,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge'),
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
            Image.asset(
              'assets/img/dashboard/knowledge.png',
              height: 200,
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
                              InkWell(
                                onTap: () {},
                                child: EasyAccess(
                                    path: 'assets/img/menu/complain.png',
                                    color: Colors.green,
                                    text: 'COMPLAIN'),
                              ),
                              InkWell(
                                onTap: () {},
                                child: EasyAccess(
                                    path: 'assets/img/menu/tanggapan.png',
                                    color: Colors.orange,
                                    text: 'TANGGAPAN'),
                              ),
                              InkWell(
                                onTap: () {},
                                child: EasyAccess(
                                    path: 'assets/img/menu/report.png',
                                    color: Colors.red,
                                    text: 'RIPORT'),
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Karyawan Cuti',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      loadingCuti
                          ? const Center(child: CircularProgressIndicator())
                          : dataResponseCuti
                              ? buildCarousel()
                              : const Center(child: Text('No data available')),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Karyawan Izin',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Karyawan Dinas',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
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
