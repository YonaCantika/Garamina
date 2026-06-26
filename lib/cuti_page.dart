import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'components/actionComponent.dart';
import 'components/welcome.dart';
import 'components/customExpandedContainer.dart';
import 'package:garamina/services/api_services.dart';

class CutiPage extends StatefulWidget {
  @override
  _CutiPageState createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> cutiData = [];
  bool loading = true;
  bool dataResponse = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
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
      loading = false;
      final data = jsonDecode(response.body);
      data.length <= 0 ? dataResponse = false : dataResponse = true;
      setState(() {
        cutiData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuti'),
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
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          WelcomeSection(),
          Container(
            height: 150,
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              items: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/img/slider/1.JPG'),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/img/slider/2.JPG'),
                ),
              ],
            ),
          ),
          CustomExpandedContainer(
            title: 'Karyawan Cuti',
            data: cutiData,
            loading: loading,
            dataResponse: dataResponse,
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
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
