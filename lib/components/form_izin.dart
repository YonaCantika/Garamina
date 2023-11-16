import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../auth_state.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:file_picker/file_picker.dart';

class FormIzin extends StatefulWidget {
  @override
  _FormIzinState createState() => _FormIzinState();
}

class _FormIzinState extends State<FormIzin> {
  List<Map<String, dynamic>> dataCuti = [];
  String selectedTipeCuti = '';
  List<Map<String, dynamic>> kategoriIzin = [];
  String selectedKategoriIzin = '';
  List<Map<String, dynamic>> tipeIzin = [];
  String selectedTipeIzin = '';

  List<Map<String, dynamic>> dataPengganti = [];
  String selectedPengganti = '';
  TextEditingController mulaiCutiController = TextEditingController();
  TextEditingController selesaiCutiController = TextEditingController();
  TextEditingController atasanController = TextEditingController();
  TextEditingController keteranganIzinController = TextEditingController();
  int _ready = 0;
  String? idAtasan;
  TextEditingController penggantiController = TextEditingController();
  String? ket;

  var picked;
  String? file = 'null';

  @override
  void initState() {
    super.initState();
    _getPengganti();
    _getAtasan();
    _getKategoriIzin();
    _getTipeIzin();


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
          _ready += 1;
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
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

  Future<void> _getKategoriIzin() async{
    final response = await http.post(
      Uri.parse('https://garamina.com/fintech2/integrasi/android/cuti_izin/kategory_izin'),
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
    );

    if (response.statusCode == 200) {
      kategoriIzin = List<Map<String, dynamic>>.from(json.decode(response.body));
      // print(kategoriIzin);
      if (kategoriIzin.isNotEmpty) {
        selectedKategoriIzin = kategoriIzin[0]['id_kategori'].toString();
        // print(selectedKategoriIzin);
      }
      setState(() {
        _ready +=1;
      });
    }
  }

  Future<void> _getTipeIzin() async{
    final response = await http.post(
      Uri.parse('https://garamina.com/fintech2/integrasi/android/cuti_izin/tipe_izin'),
      headers: {
        'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
      },
    );

    if (response.statusCode == 200) {
      tipeIzin = List<Map<String, dynamic>>.from(json.decode(response.body));
      // print(tipeIzin);
      if (tipeIzin.isNotEmpty) {
        selectedTipeIzin = tipeIzin[0]['id_tipe'].toString();
        // print(selectedTipeIzin);
      }
    }
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

  void _sendDataCuti(idPegawai, nik) async {
    String filePath = picked.files.first.path.toString();
    File file = File(filePath);

    var request = http.MultipartRequest('POST', Uri.parse('https://garamina.com/fintech2/integrasi/android/cuti_izin/insert_izin'));
    request.headers['APIKEY'] = '8deca313c70c6195eba4208b8dc6d56b';
    request.fields['idPegawai'] = idPegawai.toString();
    request.fields['idPengganti'] = selectedPengganti.toString();
    request.fields['idAtasan'] = idAtasan.toString();
    request.fields['idKategori'] = selectedKategoriIzin.toString();
    request.fields['idTipe'] = selectedTipeIzin.toString();
    request.fields['mulaiHadir'] = mulaiCutiController.text.toString();
    request.fields['selesaiHadir'] = selesaiCutiController.text.toString();
    request.fields['keteranganHadir'] = keteranganIzinController.text.toString();
    request.fields['nik'] = nik.toString();
    request.files.add(http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();

      final parsedData = json.decode(responseData);
      if(parsedData[0]["status"] == true){
        Navigator.of(context).pop();
        _showDialog("Sukses", "Pengajuan izin berhasil dikirim!");
      }

      // print(parsedData[0]["status"]);
      // Tangani respon yang diterima dari server
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
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ready == 3
                  ? Column(
                children: [
                  const Text(
                    'Pengajuan Izin',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // tanggal
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Mulai Izin'),
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
                              decoration: const InputDecoration(labelText: 'Selesai Izin'),
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
                  // keterangan
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Keterangan'),
                    controller: keteranganIzinController,
                  ),
                  // pengganti
                  TypeAheadField<Map<String, dynamic>>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: penggantiController,
                      decoration: const InputDecoration(
                        labelText: 'Pengganti',
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return dataPengganti
                          .where((item) =>
                          item['nama'].toLowerCase().contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['nik'].toString()} - ${suggestion['nama'].toString()}'),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      penggantiController.text = suggestion['nama'].toString();
                      selectedPengganti = suggestion['nik'].toString();
                    },
                  ),
                  // atasan
                  TextFormField(
                    controller: atasanController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Atasan'),
                  ),
                  // kategori izin
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedKategoriIzin,
                        items: kategoriIzin.map((Map<String, dynamic> kategoriIzin) {
                          final String idKategori = kategoriIzin['id_kategori'].toString();
                          return DropdownMenuItem<String>(
                            value: idKategori,
                            child: Text(kategoriIzin['nama']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (kategoriIzin.any((kategoriIzin) => kategoriIzin['id_kategori'].toString() == newValue)) {
                            setState(() {
                              selectedKategoriIzin = newValue!;
                              final selectedCutiData = kategoriIzin.firstWhere((kategoriIzin) => kategoriIzin['id_kategori'].toString() == newValue);
                            });
                            // print(selectedKategoriIzin);
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Kategori Izin'),
                      ),
                    ],
                  ),
                  // tipe izin
                  Visibility(
                    visible: selectedKategoriIzin == '579', 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedTipeIzin,
                          items: tipeIzin.map((Map<String, dynamic> tipeIzin) {
                            final String idTipe = tipeIzin['id_tipe'].toString();
                            return DropdownMenuItem<String>(
                              value: idTipe,
                              child: Text(tipeIzin['nama']),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (tipeIzin.any((tipeIzin) => tipeIzin['id_tipe'].toString() == newValue)) {
                              String ketPump = '';
                              for(int i = 0; i< tipeIzin.length; i++){
                                if(tipeIzin[i]['id_tipe'].toString() == newValue.toString()){
                                  ketPump = tipeIzin[i]['ket'];
                                }
                              }
                              setState(() {
                                selectedTipeIzin = newValue!;
                                ket = ketPump;
                              });
                              // print(ket);
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Tipe Izin'),
                          isExpanded: true,
                        ),
                        const SizedBox(height: 10,),
                        Text(ket?? '', style: const TextStyle(color: Colors.red),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // document
                  file == 'null'?
                    SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          picked = await FilePicker.platform.pickFiles();

                          if (picked != null && picked.files.isNotEmpty) {
                            setState(() {
                              file = picked.files.first.name.toString();
                            });
                            // print('File yang diunggah: ${picked.files.first.name}');
                            // print(picked);
                            // print(file);
                            // Lakukan sesuatu dengan file yang diunggah di sini
                          } else {
                            // print('Pemilihan file dibatalkan.');
                          }
                        } catch (e) {
                          // print('Terjadi kesalahan: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('UPLOAD FILE'),
                    ),
                  ) :
                    Text('Document: ${file!}', style: const TextStyle(fontStyle: FontStyle.italic),),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _sendDataCuti(authState.idPeg, authState.nik);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Ajukan Izin'),
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
