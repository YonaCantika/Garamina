import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_state.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:garamina/services/api_services.dart';

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
  TextEditingController penggantiController = TextEditingController();
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getDataCuti();

    _getPengganti();
  }

  Future<void> _getPengganti() async {
    try {
      final response = await http.post(
        Uri.parse(
            ApiServices.allPegawai),
        headers: {
          'APIKEY': ApiServices.apiKey,
        },
        body: {
          'empid': '797',
        },
      );

      if (response.statusCode == 200) {
        dataPengganti =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (dataPengganti.isNotEmpty) {
          selectedPengganti = dataPengganti[0]['nik'].toString();
        }
        setState(() {
          _ready += 1;
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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
      Uri.parse(
          ApiServices.cuti),
      headers: {
        'APIKEY': ApiServices.apiKey,
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
        _ready += 1;
      });
      // try {
      //
      //   } catch (e) {
      //   // Handle error
      // }
    }
  }

  Future<void> _getAtasan(idPeg) async {
    count++;
    try {
      final response = await http.post(
        Uri.parse(
            ApiServices.atasanLangsung),
        headers: {
          'APIKEY': ApiServices.apiKey,
        },
        body: {
          'empid': idPeg.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        atasanController.text =
            '${responseData[0]['nik_atasan']} - ${responseData[0]['nama_atasan']}';
        idAtasan = responseData[0]['nik_atasan'];
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  int _hitungJumlahHariCuti() {
    DateTime mulaiCuti =
        DateFormat("dd-MM-yyyy").parse(mulaiCutiController.text);
    DateTime selesaiCuti =
        DateFormat("dd-MM-yyyy").parse(selesaiCutiController.text);

    if (mulaiCuti.isAfter(selesaiCuti)) {
      return 0;
    }

    int jumlahHariCuti = selesaiCuti.difference(mulaiCuti).inDays + 1;

    return jumlahHariCuti;
  }

  void _ajukanCuti(nik, idPeg) {
    int jumlahHariCuti = _hitungJumlahHariCuti();
    print(jumlahHariCuti);
    int sisaCuti = int.tryParse(sisaCutiController.text) ?? 0;
    print(sisaCuti);
    print(mulaiCutiController.text);
    print(selesaiCutiController.text);

    try {
      _sendDataCuti(
        selectedTipeCuti,
        int.parse(idPeg),
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

      sisaCutiController.text = sisaCuti.toString();
    } catch (e) {
      print(e);
    }
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
  ) async {
    final response = await http.post(
      Uri.parse(
          ApiServices.insertCuti),
      headers: {
        'APIKEY': ApiServices.apiKey,
      },
      body: {
        'idTipe': idTipe.toString(),
        'idPegawai': idPegawai.toString(),
        'idPengganti': idPengganti.toString(),
        'idAtasan': idAtasan.toString(),
        'mulaiCuti': mulaiCuti.toString(),
        'selesaiCuti': selesaiCuti.toString(),
        'jatahCuti': sisaCuti.toString(),
        'lokasiCuti': lokasiCuti.toString(),
        'telpCuti': telpCuti.toString(),
        'keteranganCuti': keteranganCuti.toString(),
        'nik': nik.toString()
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData[0]['status'] == true) {
        Navigator.of(context).pop();
        _showDialog("Berhasil", responseData[0]['pesan']);
      } else {
        _showDialog("Gagal", responseData[0]['pesan']);
      }
    } else {
      _showDialog("Gagal", "server bermasalah!!");
    }
  }

  void _showDialog(String status, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(status!),
          content: Text(message),
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
    count <= 1 ? _getAtasan(authState.idPeg) : null;
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ready == 2
                  ? Column(
                      children: [
                        const Text(
                          'Pengajuan Cuti',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedTipeCuti,
                              items:
                                  dataCuti.map((Map<String, dynamic> cutiData) {
                                final String idTipe =
                                    cutiData['idTipe'].toString();
                                return DropdownMenuItem<String>(
                                  value: idTipe,
                                  child: Text(cutiData['namaCuti']),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (dataCuti.any((cutiData) =>
                                    cutiData['idTipe'].toString() ==
                                    newValue)) {
                                  setState(() {
                                    selectedTipeCuti = newValue!;
                                    final selectedCutiData =
                                        dataCuti.firstWhere((cutiData) =>
                                            cutiData['idTipe'].toString() ==
                                            newValue);
                                    jatahCutiController.text =
                                        selectedCutiData['jatahCuti']
                                            .toString();
                                    sisaCutiController.text =
                                        selectedCutiData['sisa'].toString();
                                  });
                                }
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Tipe Cuti'),
                            ),
                          ],
                        ),
                        TypeAheadField<Map<String, dynamic>>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: penggantiController,
                            decoration: const InputDecoration(
                              labelText: 'Pengganti',
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return dataPengganti
                                .where((item) => item['nama']
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(
                                  '${suggestion['nik'].toString()} - ${suggestion['nama'].toString()}'),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            penggantiController.text =
                                suggestion['nama'].toString();
                            selectedPengganti = suggestion['nik'].toString();
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Mulai Cuti'),
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
                                    decoration: const InputDecoration(
                                        labelText: 'Selesai Cuti'),
                                    controller: selesaiCutiController,
                                    onTap: () {
                                      _selectDate(
                                          context, selesaiCutiController);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Jatah Cuti'),
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
                                    decoration: const InputDecoration(
                                        labelText: 'Sisa Cuti'),
                                    controller: sisaCutiController,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Lokasi Cuti'),
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
                                    decoration: const InputDecoration(
                                        labelText: 'No. Telpon'),
                                    controller: telpCutiController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: atasanController,
                          readOnly: true,
                          decoration:
                              const InputDecoration(labelText: 'Atasan'),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Keterangan'),
                          controller: keteranganCutiController,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _ajukanCuti(authState.nik!, authState.idPeg!);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Ajukan Cuti'),
                          ),
                        ),
                      ],
                    )
                  : const Column(
                      children: [Text("Loading...")],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
