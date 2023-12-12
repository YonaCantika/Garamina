import 'package:flutter/material.dart';
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

class DataAbsenPage extends StatefulWidget {
  @override
  _DataAbsenPageState createState() => _DataAbsenPageState();
}

class _DataAbsenPageState extends State<DataAbsenPage> {
  List<Map<String, dynamic>> dataSurvei = [];
  bool isSurvei = false;

  @override
  void initState() {
    super.initState();
    listSurvei();
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
        Uri.parse(
            'https://ptgaram.com/api/status_absen_emergency/insert_login_emergency'),
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
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
        print(responseData);
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> listSurvei() async {
    final apiUrl = Uri.parse(
        'http://192.168.1.252/fintech2/integrasi/android/survei/list_survei');

    final response = await http.post(
      apiUrl,
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'empId': '797',
        'tanggal': '2023-11-28',
      },
    );
    print('from data: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        dataSurvei = List<Map<String, dynamic>>.from(data);
        isSurvei = dataSurvei[0]['status'];
      });

      print('from data: $data');
      print('from dataSurvei: ${dataSurvei[0]['status']}');
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
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
          // Bagian 1: Selamat Datang dengan Background Biru
          WelcomeSection(),
          // Bagian 2: Carousel Slider
          CarouselSection(),
          // Bagian 3: ListView dengan Border Radius di Atas
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
                  // Judul "Data Karyawan"
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
                  // Content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0), // Padding sebelah kiri
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
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final idPeg = authState.idPeg;
                                if (idPeg != null) {
                                  try {
                                    final responseData =
                                        await sendAbsenRequest(idPeg);
                                    print(responseData);

                                    absenState.setAbsenData(
                                      checkStatusPegawai:
                                          responseData['check_status_pegawai'],
                                      checkStatusSPPD:
                                          responseData['check_status_sppd'],
                                      checkStatusDetasering: responseData[
                                          'check_status_detasering'],
                                      checkStatus: responseData['check_status'],
                                      checkShiftM:
                                          responseData['check_shift_M'],
                                      koordinat: responseData['koordinat'],
                                      statusCuti: responseData['status_cuti'],
                                      jarakKantor: responseData['jarak_kantor'],
                                      status: responseData['status'],
                                      msg: responseData['msg'],
                                    );

                                    if (prefs.getString('koordinat') != null) {
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
                                      await prefs.setString('koordinat',
                                          responseData['koordinat'].toString());
                                    }

                                    shareDataEmergency(
                                        authState.idPeg,
                                        authState.nik,
                                        authState.namaUser,
                                        authState.costCenter,
                                        authState.username,
                                        authState.password,
                                        absenState.koordinat);
                                    if (responseData['check_status'] == 'A-' &&
                                        isSurvei == true) {
                                      // redirect ke halaman survei
                                    }
                                    // ignore: use_build_context_synchronously
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
                                // if (prefs.getString('absenData') != null) {
                                //   print('yesss');
                                //   showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //         title: const Text("Gagal"),
                                //         content: const Text(
                                //             "Terdapat data absen yang belum di sinkrinisasi"),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //               Navigator.of(context)
                                //                   .pushReplacement(
                                //                 MaterialPageRoute(
                                //                   builder: (context) =>
                                //                       DataAbsenOfflinePage(),
                                //                 ),
                                //               );
                                //             },
                                //             child: Text('OK'),
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );
                                // } else {

                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                primary: Colors.orange,
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
      Uri.parse(
          'https://garamina.com/fintech2/integrasi/android/login/v_absen'),
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
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
