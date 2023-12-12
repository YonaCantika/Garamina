import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'components/actionComponent.dart';

import 'components/welcome.dart';
import 'components/carousel.dart';
import 'components/customExpandedContainer.dart';

class JadwalPage extends StatefulWidget {
  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> jadwalData = [];
  bool dataResponseDinas = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final apiUrl = Uri.parse(
        'https://garamina.com/fintech2/integrasi/android/report/jadwal_kerja');

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'empId': '797',
        'tahun_bln': '2023-04',
      },
    );

    if (response.statusCode == 200) {
      loading = false;
      final data = jsonDecode(response.body);
      print(data);
      data.length <= 0 ? dataResponseDinas = false : dataResponseDinas = true;
      setState(() {
        jadwalData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal'),
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
          // Bagian 1: Selamat Datang dengan Background Biru
          WelcomeSection(),
          // Bagian 2: Carousel Slider
          CarouselSection(),
          // Bagian 3: ListView dengan Border Radius di Atas
          CustomExpandedContainer(
            title: 'Jadwal Shift',
            data: jadwalData,
            loading: loading,
            dataResponse: dataResponseDinas,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(jadwalData[index]['NAMA_HARI']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Masuk: ${jadwalData[index]['JAM_MASUK']}'),
                        Text('Pulang: ${jadwalData[index]['JAM_PULANG']}'),
                      ],
                    ),
                    trailing: Text('${jadwalData[index]['TANGGAL']}'),
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
