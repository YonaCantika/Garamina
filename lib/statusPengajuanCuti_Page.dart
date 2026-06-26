import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:garamina/components/form_cuti.dart';
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

class StatusPengajuanCutiPage extends StatefulWidget {
  @override
  _StatusPengajuanCutiPageState createState() =>
      _StatusPengajuanCutiPageState();
}

class _StatusPengajuanCutiPageState extends State<StatusPengajuanCutiPage> {
  int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> pengajuanCutiData = [];
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
        ApiServices.reportMyCuti);

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
        pengajuanCutiData = List<Map<String, dynamic>>.from(data);
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
        title: const Text('Status Cuti'),
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
                      return FormCuti();
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
                child: const Text('Ajukan Cuti'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomExpandedContainer(
            title: 'Pengajuan Cuti',
            data: pengajuanCutiData,
            loading: loading,
            dataResponse: dataResponse,
            itemBuilder: (context, index) {
              final nomorCuti = pengajuanCutiData[index]['NOMOR_CUTI'];
              final tipeCuti = pengajuanCutiData[index]['TIPE_CUTI'];
              final keterangan = pengajuanCutiData[index]['KETERANGAN'];
              final tanggalPengajuan =
                  pengajuanCutiData[index]['TANGGAL_PENGAJUAN'];
              final mulaiCuti = pengajuanCutiData[index]['MULAI_CUTI'];
              final selesaiCuti = pengajuanCutiData[index]['SELESAI_CUTI'];
              final lamaCuti = pengajuanCutiData[index]['LAMA_CUTI'];
              final statusCuti = pengajuanCutiData[index]['STATUS_CUTI'];
              return Column(
                children: [
                  ListTile(
                    title: Text('Tipe Cuti: $tipeCuti'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Keterangan: $keterangan'),
                        Text('Mulai Cuti: $mulaiCuti'),
                        Text('Selesai Cuti: $selesaiCuti'),
                        Text('Status: $statusCuti'),
                      ],
                    ),
                    trailing: statusCuti == 'Sudah Approval'
                        ? const Icon(Icons.verified,
                            size: 30, color: Colors.green)
                        : statusCuti == 'Belum Approval'
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
      // Bagian 4: Menu dengan Icon dan Text di Bawah
      // bottomNavigationBar: BottomMenu(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: (int index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //     if (index == 1) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => HistoriPage(),
      //         ),
      //       );
      //     }
      //     if (index == 2) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => DataAbsenPage(),
      //         ),
      //       );
      //     }
      //     if (index == 3) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => NotifPage(),
      //         ),
      //       );
      //     }
      //     if (index == 4) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => AkunPage(),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
