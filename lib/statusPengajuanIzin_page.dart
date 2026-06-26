import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:garamina/components/form_izin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'components/actionComponent.dart';
import 'components/customExpandedContainer.dart';
import 'histori_page.dart';
import 'dataAbsen_page.dart';
import 'notif_page.dart';
import 'akun_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'package:garamina/services/api_services.dart';

class StatusPengajuanIzinPage extends StatefulWidget {
  @override
  _StatusPengajuanIzinPageState createState() =>
      _StatusPengajuanIzinPageState();
}

class _StatusPengajuanIzinPageState extends State<StatusPengajuanIzinPage> {
  int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> pengajuanIzinData = [];
  int count = 0;
  bool dataResponse = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromApi(idPeg) async {
    count++;
    final apiUrl = Uri.parse(
        ApiServices.reportMyIzin);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {'empId': idPeg.toString()},
    );

    if (response.statusCode == 200) {
      loading = false;
      final data = jsonDecode(response.body);
      data.length <= 0 ? dataResponse = false : dataResponse = true;
      print(data);
      setState(() {
        pengajuanIzinData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    count < 1 ? fetchDataFromApi(authState.idPeg) : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Izin'),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return FormIzin();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Ajukan Izin'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomExpandedContainer(
            title: 'Data Pengajuan Izin',
            data: pengajuanIzinData,
            loading: loading,
            dataResponse: dataResponse,
            itemBuilder: (context, index) {
              final nomorIzin = pengajuanIzinData[index]['NOMOR_IZIN'];
              final kategoriIzin = pengajuanIzinData[index]['KATEGORI_IZIN'];
              final tipeIzin = pengajuanIzinData[index]['TIPE_IZIN'];
              final keterangan = pengajuanIzinData[index]['KETERANGAN'];
              final tanggalPengajuan =
                  pengajuanIzinData[index]['TANGGAL_PENGAJUAN'];
              final mulaiIzin = pengajuanIzinData[index]['MULAI_IZIN'];
              final selesaiIzin = pengajuanIzinData[index]['SELESAI_IZIN'];
              final lamaIzin = pengajuanIzinData[index]['LAMA_IZIN'];
              final statusIzin = pengajuanIzinData[index]['STATUS_IZIN'];
              return Column(
                children: [
                  ListTile(
                    title: Text('Kategori: $kategoriIzin'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipe Izin: $tipeIzin'),
                        Text('Keterangan: $keterangan'),
                        Text('Mulai Izin: $mulaiIzin'),
                        Text('Selesai Izin: $selesaiIzin'),
                        Text('Status: $statusIzin'),
                      ],
                    ),
                    trailing: statusIzin == 'Sudah Approval'
                        ? const Icon(Icons.verified,
                            size: 30, color: Colors.green)
                        : statusIzin == 'Belum Approval'
                            ? const Icon(Icons.hourglass_top,
                                size: 30, color: Colors.orange)
                            : const Icon(Icons.rate_review,
                                size: 30, color: Colors.red),
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
