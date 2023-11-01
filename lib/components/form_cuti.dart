import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_state.dart';

class FormCuti extends StatefulWidget {
  @override
  _FormCutiState createState() => _FormCutiState();
}

class _FormCutiState extends State<FormCuti> {
  List<Map<String, dynamic>> dataCuti = [];
  List<Map<String, dynamic>> dataPengganti = [];
  String selectedTipeCuti = '';
  String selectedPengganti = '';
  TextEditingController mulaiCutiController = TextEditingController();
  TextEditingController selesaiCutiController = TextEditingController();
  TextEditingController atasanController = TextEditingController();
  TextEditingController jatahCutiController = TextEditingController();
  TextEditingController sisaCutiController = TextEditingController();
  TextEditingController lokasiCutiController = TextEditingController();
  TextEditingController telpCutiController = TextEditingController();
  TextEditingController keteranganCutiController = TextEditingController();
  int _ready = 0;
  String? idAtasan;

  @override
  void initState() {
    super.initState();
    _getDataCuti();
    _getAtasan();
    _getPengganti();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _getDataCuti() async {

    final response = await http.post(
      Uri.parse('https://garamina.com/fintech2/integrasi/android/cuti_izin/cuti'),
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'empid': '797',
        'tanggal': '2023-10-11',
      },
    );

    if (response.statusCode == 200) {
      dataCuti = List<Map<String, dynamic>>.from(json.decode(response.body));
      if (dataCuti.isNotEmpty) {
        selectedTipeCuti = dataCuti[0]['idTipe'].toString();
        jatahCutiController.text = dataCuti[0]['jatahCuti'].toString();
        sisaCutiController.text = dataCuti[0]['sisa'].toString();
      }
      setState(() {
        _ready +=1;
      });
      // try {
      //
      //   } catch (e) {
      //   // Handle error
      // }
    }
  }

  Future<void> _getAtasan() async {
    try {
      final response = await http.post(
        Uri.parse('https://garamina.com/fintech2/integrasi/android/cuti_izin/atasan_langsung'),
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
        },
        body: {
          'empid': '797',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        atasanController.text = '${responseData[0]['nik_atasan']} - ${responseData[0]['nama_atasan']}';
        idAtasan = responseData[0]['nik_atasan'];
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _getPengganti() async {
    try {
      final response = await http.post(
        Uri.parse('https://garamina.com/fintech2/integrasi/android/cuti_izin/all_pegawai'),
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
        },
        body: {
          'empid': '797',
        },
      );

      if (response.statusCode == 200) {
        dataPengganti = List<Map<String, dynamic>>.from(json.decode(response.body));
        if (dataPengganti.isNotEmpty) {
          selectedPengganti = dataPengganti[0]['nik'].toString();
        }
        setState(() {
          _ready +=1;
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  int _hitungJumlahHariCuti() {
    DateTime mulaiCuti = DateFormat("dd-MM-yyyy").parse(mulaiCutiController.text);
    DateTime selesaiCuti = DateFormat("dd-MM-yyyy").parse(selesaiCutiController.text);

    if (mulaiCuti.isAfter(selesaiCuti)) {
      return 0;
    }

    int jumlahHariCuti = selesaiCuti.difference(mulaiCuti).inDays + 1;

    return jumlahHariCuti;
  }

  void _ajukanCuti(nik) {
    int jumlahHariCuti = _hitungJumlahHariCuti();
    print(jumlahHariCuti);
    int sisaCuti = int.tryParse(sisaCutiController.text) ?? 0;
    print(sisaCuti);
    print(mulaiCutiController.text);
    print(selesaiCutiController.text);

    try {
      // String mulaiCuti = '${mulaiCutiController.text.substring(5, 8)}-${mulaiCutiController.text.substring(, 5)}-${mulaiCutiController.text.substring(0, 2)}';
      // String selesaiCuti = '${selesaiCutiController.text.substring(6, 10)}-${selesaiCutiController.text.substring(3, 5)}-${selesaiCutiController.text.substring(0, 2)}';
      // print(mulaiCuti);

      _sendDataCuti(
        selectedTipeCuti,
        '797',
        selectedPengganti,
        idAtasan,
        mulaiCutiController.text.toString(),
        selesaiCutiController.text.toString(),
        jatahCutiController.text,
        jumlahHariCuti,
        sisaCuti,
        lokasiCutiController.text,
        telpCutiController.text,
        keteranganCutiController.text,
        int.parse(nik),
      );
      sisaCuti -= jumlahHariCuti;
      sisaCutiController.text = sisaCuti.toString();
    }catch(e){
      print(e);
    }


    // if (jumlahHariCuti > 0 && jumlahHariCuti <= sisaCuti) {
    //
    // } else {
    //   // Tampilkan pesan kesalahan jika jumlah hari cuti melebihi sisa cuti.
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Jumlah hari cuti melebihi sisa cuti yang tersedia.'),
    //     ),
    //   );
    // }
  }

  void _sendDataCuti(
      idTipe,
      idPegawai,
      idPengganti,
      idAtasan,
      mulaiCuti,
      selesaiCuti,
      jatahCuti,
      jumlahCuti,
      sisaCuti,
      lokasiCuti,
      telpCuti,
      keteranganCuti,
      nik,
      ) async{
    print('${idTipe}, ${idPegawai}, ${idPengganti}, ${idAtasan}, ${mulaiCuti}, ${selesaiCuti}, ${jatahCuti}, ${jumlahCuti}, ${sisaCuti}, ${lokasiCuti}, ${telpCuti}, ${keteranganCuti}, ${nik}');

    final response = await http.post(
      Uri.parse('https://garamina.com/fintech2/integrasi/android/cuti_izin/insert_cuti'),
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
      body: {
        'idTipe' : idTipe.toString(),
        'idPegawai' : idPegawai.toString(),
        'idPengganti' : idPengganti.toString(),
        'idAtasan' : idAtasan.toString(),
        'mulaiCuti' : mulaiCuti.toString(),
        'selesaiCuti' : selesaiCuti.toString(),
        'jatahCuti' : sisaCuti.toString(),
        // 'jumlahCuti' : jumlahCuti.toString(),
        // 'sisaCuti' : sisaCuti.toString(),
        'lokasiCuti' : lokasiCuti.toString(),
        'telpCuti' : telpCuti.toString(),
        'keteranganCuti' : keteranganCuti.toString(),
        'nik' : nik.toString()
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      print(responseData[0]['status']);
      print(responseData);
      if (responseData[0]['status'] == true) {
        _showDialog("Berhasil", responseData[0]['pesan']);
      } else {
        _showDialog("Gagal", responseData[0]['pesan']);
      }
    } else {
      _showDialog("Gagal", "server bermasalah!!");
    }

    // try {
    //
    // } catch (e) {
    //   print('gagal');
    //   print(e);
    //   // showErrorDialog('Periksa koneksi anda lalu coba kembali.');
    // }
  }

  void _showDialog(String status, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${status!}'),
          content: Text('${message}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ready == 2 ?
               Column(
                children: [
                  const Text(
                    'Pengajuan Cuti',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedTipeCuti,
                        items: dataCuti.map((Map<String, dynamic> cutiData) {
                          final String idTipe = cutiData['idTipe'].toString();
                          return DropdownMenuItem<String>(
                            value: idTipe,
                            child: Text(cutiData['namaCuti']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (dataCuti.any((cutiData) => cutiData['idTipe'].toString() == newValue)) {
                            setState(() {
                              selectedTipeCuti = newValue!;
                              final selectedCutiData = dataCuti.firstWhere((cutiData) => cutiData['idTipe'].toString() == newValue);
                              jatahCutiController.text = selectedCutiData['jatahCuti'].toString();
                              sisaCutiController.text = selectedCutiData['sisa'].toString();
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Tipe Cuti'),
                      ),
                    ],
                  ),
                  // tanggal
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Mulai Cuti'),
                              controller: mulaiCutiController,
                              onTap: () {
                                _selectDate(context, mulaiCutiController);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Selesai Cuti'),
                              controller: selesaiCutiController,
                              onTap: () {
                                _selectDate(context, selesaiCutiController);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // jatah dan sisa cuti
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Jatah Cuti'),
                              controller: jatahCutiController,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Sisa Cuti'),
                              controller: sisaCutiController,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // lokasi dan nomor hp
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Lokasi Cuti'),
                              controller: lokasiCutiController,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'No. Telpon'),
                              controller: telpCutiController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // atasan
                  TextFormField(
                    controller: atasanController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Atasan'),
                  ),
                  // pengganti
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedPengganti,
                        items: dataPengganti.map((Map<String, dynamic> dataPengganti) {
                          final String nik = dataPengganti['nik'].toString();
                          return DropdownMenuItem<String>(
                            value: nik,
                            child: Text(dataPengganti['nama']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (dataPengganti.any((dataPengganti) => dataPengganti['nik'].toString() == newValue)) {
                            setState(() {
                              selectedPengganti = newValue!;
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Pengganti'),
                      ),
                    ],
                  ),
                  // keterangan
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Keterangan'),
                    controller: keteranganCutiController,
                  ),
                  const SizedBox(height: 12), // Spasi antara password dan tombol login
                  SizedBox(
                    width: double
                        .infinity, // Membuat tombol login memenuhi lebar
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        _ajukanCuti(authState.nik!);
                        // Tambahkan kode untuk mengirim data pengajuan cuti ke server atau penyimpanan lokal
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Ajukan Cuti'),
                    ),
                  ),
                ],
              ) :
                const Column(
                  children: [Text("Loading...")],
                ),
            ]
          ),
        ),
      ),
    );
  }
}
