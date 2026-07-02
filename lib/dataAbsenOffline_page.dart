import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'absen_offline_page.dart';
import 'components/actionComponent.dart';
import 'login_page.dart';
import 'package:garamina/services/api_services.dart';

class DataAbsenOfflinePage extends StatefulWidget {
  @override
  _DataAbsenOfflinePageState createState() => _DataAbsenOfflinePageState();
}

class _DataAbsenOfflinePageState extends State<DataAbsenOfflinePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? idPeg;
  String? namaUser;
  String? costCenter;
  String? checkStatus;
  String? checkShiftM;
  String? koordinat;
  String? nik;

  String? absenDataString;

  List<Map<String, dynamic>> absenListJson = [];

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences();
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String imageToBase64(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> sinkronisasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('absenData') == null) {
      showErrorDialog('Data Kosong',
          'Anda tidak bisa melakukan sinkronisasi karena data absen kosong!');
    }

    final List<dynamic> absenDataList = json.decode(absenDataString!);
    print(absenDataList.toString());

    for (var index = 0; index < absenDataList.length; index++) {
      Map<String, dynamic> jsonData = json.decode(absenDataList[index]);
      String imagePath = jsonData["foto"];

      if (imagePath != null) {
        File imageFile = File(imagePath);
        if (imageFile.existsSync()) {
          List<int> imageBytes = imageFile.readAsBytesSync();
          String base64Image = base64Encode(imageBytes);
          jsonData["foto"] = base64Image;
        }
        absenDataList[index] = json.encode(jsonData);
      }
    }

    print(absenDataList.toString());

    final response = await http.post(
      Uri.parse(
          ApiServices.insertAbsenEmergencyLogin),
      headers: {
        'APIKEY': ApiServices.apiKey,
        'Content-Type': 'application/json',
      },
      body: absenDataList.toString(),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData[0]['status'] == true) {
        await prefs.remove('absenData');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        showErrorDialog('Gagal', 'Sinkronisasi Gagal!');
      }
    } else {
      showErrorDialog('Gagal', 'Server masih maintenance');
    }
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('idPeg') == null ||
        prefs.getString('koordinat') == null) {
      showErrorDialog('Data Kosong',
          'Data anda belum tercatat di menu emergency, hubungi admin untuk informasi lebih lanjut!');
    }

    absenDataString = prefs.getString('absenData');
    print(absenDataString);

    if (absenDataString != null) {
      final List<dynamic> absenDataList = json.decode(absenDataString!);
      print(absenDataList);

      if (absenDataList.isNotEmpty) {
        final List<Map<String, dynamic>> absenList = absenDataList
            .map((item) => json.decode(item))
            .cast<Map<String, dynamic>>()
            .toList();

        final List<Map<String, dynamic>> reversedAbsenList =
            List.from(absenList.reversed);

        setState(() {
          absenListJson = reversedAbsenList;
        });
        // print(absenListJson);
      }
    }

    setState(() {
      idPeg = prefs.getString('idPeg');
      namaUser = prefs.getString('namaUser');
      costCenter = prefs.getString('costCenter');
      checkStatus = prefs.getString('checkStatus');
      checkShiftM = prefs.getString('checkShiftM');
      koordinat = prefs.getString('koordinat');
      nik = prefs.getString('nik');
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            color: Colors.blue,
            height: 100,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    namaUser ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    costCenter ?? 'Cost Center',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  dialog(
                      'Peringatan',
                      'Pastikan nama dan cost center sesuai sebelum melakukan absen darurat',
                      true);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Absen Darurat'),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Center(
              child: Text(
                'NB: Waktu Absen di Convert Menjadi WIB',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
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
                      'Histori Absen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: absenListJson.isEmpty
                        ? const Center(
                            child: Text('Belum ada absen'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: absenListJson.length,
                            itemBuilder: (context, index) {
                              final status = absenListJson[index]['status'];
                              final note = absenListJson[index]['note'];
                              final datetime = absenListJson[index]['datetime'];
                              final emoticon = absenListJson[index]['emoticon'];
                              final foto = absenListJson[index]['foto'];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: FileImage(File(foto)),
                                    ),
                                    title: Text(
                                        'Absen ${status == "out" ? "Pulang" : "Masuk"}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${datetime.substring(0, 10)}'),
                                        Text(
                                          '$note',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    trailing:
                                        Text('${datetime.substring(11, 19)}'),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dialog(header, message, opsi) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(header),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Lanjutkan'),
              onPressed: () {
                Navigator.of(context).pop();
                opsi == true
                    ? Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AbsenOfflinePage(),
                        ),
                      )
                    : sinkronisasi();
              },
            ),
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
