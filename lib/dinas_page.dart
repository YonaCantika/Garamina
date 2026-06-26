import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'components/actionComponent.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';
import 'components/customExpandedContainer.dart';
import 'package:garamina/services/api_services.dart';

class DinasPage extends StatefulWidget {
  @override
  _DinasPageState createState() => _DinasPageState();
}

class _DinasPageState extends State<DinasPage> {
  // int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> dinasData = [];
  bool dataResponseDinas = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
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
      loading = false;
      final data = jsonDecode(response.body);
      // print(data);
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
        title: const Text('Dinas'),
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
            title: 'Karyawan Dinas',
            data: dinasData,
            loading: loading,
            dataResponse: dataResponseDinas,
            itemBuilder: (context, index) {
              final namaPegawai = dinasData[index]['NAMA_PEGAWAI'];
              final periode = dinasData[index]['PERIODE'];
              final tujuan = dinasData[index]['TUJUAN'];

              return Column(
                children: [
                  ListTile(
                    title: Text('Nama: $namaPegawai'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tujuan: $tujuan'),
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
