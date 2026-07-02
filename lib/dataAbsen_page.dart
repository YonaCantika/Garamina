import 'package:flutter/material.dart';
import 'package:garamina/browser_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_state.dart';
import 'absen_state.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/actionComponent.dart';
import 'absen_page.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';
import 'package:garamina/services/api_services.dart';

class DataAbsenPage extends StatefulWidget {
  @override
  _DataAbsenPageState createState() => _DataAbsenPageState();
}

class _DataAbsenPageState extends State<DataAbsenPage> {
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> dataSurvei = [];
  bool isSurvei = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> shareDataEmergency(
      idPeg, nik, namaUser, costCenter, username, password, koordinat) async {
    print(username);
    print(password);
    try {
      final response = await http.post(
        Uri.parse(ApiServices.insertLoginEmergency),
        headers: {
          'APIKEY': ApiServices.apiKeyEmergency,
        },
        body: {
          'idPeg': idPeg.toString(),
          'nik': nik.toString(),
          'namaUser': namaUser.toString(),
          'costCenter': costCenter.toString(),
          'koordinat': koordinat.toString(),
          'userName': username.toString(),
          'password': password.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('SUKSES SIMPAN KE EMERGENCY: $responseData');
      } else {
        print('GAGAL SIMPAN KE EMERGENCY. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('ERROR SIMPAN KE EMERGENCY: $e');
    }
  }

  Future<void> listSurvei(idPeg) async {
    count++;
    final apiUrl = Uri.parse(ApiServices.listSurvei);

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {
        'empId': idPeg.toString(),
        'tanggal':
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      },
    );
    print('from data: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        dataSurvei = List<Map<String, dynamic>>.from(data);
        if (dataSurvei[0]['status'] == true ||
            dataSurvei[0]['status'] == 'true') {
          isSurvei = true;
        }
      });
      print('from is survei $isSurvei');
      print(dataSurvei[0]['status']);

      print('from data: $data');
      print('from dataSurvei: ${dataSurvei[0]['status']}');
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    count < 1 ? listSurvei(authState.idPeg) : null;
    final absenState = Provider.of<AbsenState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absen'),
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
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          WelcomeSection(),
          CarouselSection(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Data Karyawan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            const Text(
                              'Nama Karyawan:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.namaUser ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'NIK:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.nik ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Cost Center:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.costCenter ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Lokasi:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.lokasi ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (isSurvei == false) {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  final idPeg = authState.idPeg;
                                  if (idPeg != null) {
                                    try {
                                      final responseData =
                                          await sendAbsenRequest(idPeg);
                                      print(responseData);

                                      absenState.setAbsenData(
                                        checkStatusPegawai: responseData[
                                            'check_status_pegawai'],
                                        checkStatusSPPD:
                                            responseData['check_status_sppd'],
                                        checkStatusDetasering: responseData[
                                            'check_status_detasering'],
                                        checkStatus:
                                            responseData['check_status'],
                                        // responseData['check_status'] == 'A-A' ? '0-0' : responseData['check_status'],
                                        checkShiftM:
                                            responseData['check_shift_M'],
                                        koordinat: responseData['koordinat'],
                                        statusCuti: responseData['status_cuti'],
                                        jarakKantor:
                                            responseData['jarak_kantor'],
                                        status: responseData['status'],
                                        msg: responseData['msg'],
                                      );

                                      if (prefs.getString('koordinat') !=
                                          null) {
                                        print('not set');
                                      } else {
                                        print('set');
                                        await prefs.setString(
                                            'checkStatus',
                                            responseData['check_status']
                                                        .toString() ==
                                                    'A-A'
                                                ? '0-0'
                                                : responseData['check_status']
                                                    .toString());
                                        await prefs.setString(
                                            'checkShiftM',
                                            responseData['check_shift_M']
                                                .toString());
                                        await prefs.setString(
                                            'koordinat',
                                            responseData['koordinat']
                                                .toString());
                                      }

                                      shareDataEmergency(
                                          authState.idPeg,
                                          authState.nik,
                                          authState.namaUser,
                                          authState.costCenter,
                                          authState.username,
                                          authState.password,
                                          absenState.koordinat);
                                      if (responseData['check_status'] ==
                                              'A-' &&
                                          isSurvei == true) {}
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AbsenPage(),
                                        ),
                                      );
                                    } catch (error) {
                                      // print(error);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Gagal Melakukan Absen'),
                                            content: const Text(
                                                'Terjadi kesalahan saat melakukan absen. Silakan coba lagi.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    // jika id peg null
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Belum Bisa Melakukan Absen'),
                                        content: Text(
                                            'Terdapat ${dataSurvei.length} survei yag belum dikerjakan!!'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BrowserPage(),
                                                ),
                                              );
                                            },
                                            child: const Text('Kerjakan'),
                                          ),
                                          TextButton(
                                            child: const Text('Tutup'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Absen',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> sendAbsenRequest(String idPeg) async {
    final response = await http.post(
      Uri.parse(ApiServices.vAbsen),
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {'id_peg': idPeg},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['msg'] == 'Sukses') {
        return responseData;
      } else {
        throw Exception('Gagal melakukan absen');
      }
    } else {
      throw Exception('Gagal melakukan absen');
    }
  }
}
