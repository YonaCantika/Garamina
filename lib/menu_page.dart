import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_state.dart';
import 'absen_state.dart';
import 'absen_page.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final absenState = Provider.of<AbsenState>(context, listen: false);

    final cardContents = [
      // Content for the card
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Nama Karyawan:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            authState.namaUser ?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            'NIK:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            authState.nik ?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            'Cost Center:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            authState.costCenter ?? '',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Image.asset(
            'img/bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Card(
              elevation: 5, // Efek shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Border radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: cardContents,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final idPeg = authState.idPeg;
                  if (idPeg != null) {
                    try {
                      final responseData = await sendAbsenRequest(idPeg);

                      // Update AbsenState with the API response
                      absenState.setAbsenData(
                        checkStatusPegawai:
                            responseData['check_status_pegawai'],
                        checkStatusSPPD: responseData['check_status_sppd'],
                        checkStatusDetasering:
                            responseData['check_status_detasering'],
                        checkStatus: responseData['check_status'],
                        checkShiftM: responseData['check_shift_M'],
                        koordinat: responseData['koordinat'],
                        statusCuti: responseData['status_cuti'],
                        jarakKantor: responseData['jarak_kantor'],
                        status: responseData['status'],
                        msg: responseData['msg'],
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AbsenPage(),
                        ),
                      );
                    } catch (error) {
                      // Handle API request failure by showing an alert
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Gagal Melakukan Absen'),
                            content: Text(
                                'Terjadi kesalahan saat melakukan absen. Silakan coba lagi.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // Handle the case where idPeg is null here, e.g., by showing an error message.
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  primary: Colors.yellow, // Warna kuning
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Absen',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> sendAbsenRequest(String idPeg) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/absen'),
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
