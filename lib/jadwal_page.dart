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
import 'package:garamina/services/api_services.dart';

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
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromApi(idPeg) async {
    count++;
    final apiUrl = Uri.parse(
        ApiServices.reportJadwalKerja);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {
        'empId': idPeg.toString(),
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
    count <= 1 ? fetchDataFromApi(authState.idPeg) : null;
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
          WelcomeSection(),
          CarouselSection(),
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
