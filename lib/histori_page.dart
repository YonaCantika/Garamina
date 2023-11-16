import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'components/actionComponent.dart';
import 'components/customExpandedContainer.dart';
import 'dashboard_page.dart';
import 'notif_page.dart';
import 'akun_page.dart';
import 'dataAbsen_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';

class HistoriPage extends StatefulWidget {
  @override
  _HistoriPageState createState() => _HistoriPageState();
}

class _HistoriPageState extends State<HistoriPage> {
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> historiData = [];
  int count =0;
  bool dataResponse = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromApi(idPeg) async {
    count++;
    final apiUrl = Uri.parse('https://garamina.com/fintech2/integrasi/android/report/history_absen');

    try{
      final response = await http.post(
        apiUrl,
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
        },
        body: {
          "periodeTanggal": '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
          "idPegawai": idPeg.toString()
          // "idPegawai": "797"
        },
      );

      if (response.statusCode == 200) {
        loading = false;
        final data = jsonDecode(response.body);
        data.length <= 0 ?
        dataResponse = false: dataResponse = true;
        print(response.statusCode);
        setState(() {
          historiData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    }catch(e){
      print(e);
    }

  }



  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    count < 1 ?
    fetchDataFromApi(authState.idPeg):null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori'),
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
          CustomExpandedContainer(
            title: 'Histori Absen',
            data: historiData,
            loading: loading,
            dataResponse: dataResponse,
            itemBuilder: (context, index) {
              final tanggal = historiData[index]['TANGGAL'];
              final keterangan = historiData[index]['KETERANGAN'];

              final fotoIn = 'https://garamina.com/erp/assets/upload/${historiData[index]['FOTO_IN']}';
              final jarakIn = historiData[index]['JARAK_IN'];
              final jamIn = historiData[index]['JAM_IN'];
              final statusAbsenIn = historiData[index]['STATUS_ABSEN_IN'];

              final fotoOut = 'https://garamina.com/erp/assets/upload/${historiData[index]['FOTO_OUT']}';
              final jarakOut = historiData[index]['JARAK_OUT'];
              final jamOut = historiData[index]['JAM_OUT'];
              final statusAbsenOut = historiData[index]['STATUS_ABSEN_OUT'];
              final nilaiInsentif = historiData[index]['NILAI_INSENTIF'];
              return GestureDetector(
                onTap: () {
                  // Tampilkan alert ketika diklik
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Detail Absen:'),
                        content: Column(
                          children: [
                            historiData[index]['KETERANGAN'] == 'Libur'?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Image.asset(
                                  'assets/img/holiday.png',
                                  width: 200,
                                  height: 200,
                                ),
                                const Text("Selamat menikmati waktu bersama keluarga, semoga sehat dan bahagia selalu😊", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),)
                              ],
                            ):
                            //in
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                if (historiData[index]['FOTO_IN'] != null) // Periksa apakah ada URL gambar
                                  Image.network(
                                    fotoIn,
                                    height: 100, // Sesuaikan ukuran gambar sesuai kebutuhan Anda
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                              ],
                            ),
                            historiData[index]['FOTO_IN'] != null?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                const SizedBox(height: 10,),
                                const Text('Absen masuk', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Jarak: $jarakIn'),
                                Text('Tanggal: ${jamIn.toString().substring(0,10)}'),
                                Text('Jam: ${jamIn.toString().substring(11,19)}'),
                                Text('Status: $statusAbsenIn'),
                                // Text('Jarak Pulang: $jarakOut'),
                              ],
                            ) : historiData[index]['KETERANGAN'] == 'Masuk' || historiData[index]['KETERANGAN'] == 'Tidak Absen' ?
                            const Text("Anda belum absen masuk!"): const Text(""),
                            //out
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                if (historiData[index]['FOTO_OUT'] != null) // Periksa apakah ada URL gambar
                                  Image.network(
                                    fotoOut,
                                    height: 100, // Sesuaikan ukuran gambar sesuai kebutuhan Anda
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                              ],
                            ),
                            historiData[index]['FOTO_OUT'] != null?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                const SizedBox(height: 10,),
                                const Text('Absen Pulang', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Jarak: $jarakOut'),
                                Text('Tanggal: ${jamOut.toString().substring(0,10)}'),
                                Text('Jam: ${jamOut.toString().substring(11,19)}'),
                                Text('Status: $statusAbsenOut'),
                                Text('Uang Kehadiran: $nilaiInsentif'),
                              ],
                            ): historiData[index]['KETERANGAN'] == 'Masuk' || historiData[index]['KETERANGAN'] == 'Tidak Absen' ?
                            const Text("Anda belum absen Pulang!", style: TextStyle(color: Colors.orange),): const Text(""),

                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Tutup dialog
                            },
                            child: const Text('Tutup'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Tanggal: $tanggal'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keterangan: $keterangan'),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
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
      //     if (index == 0) {
      //       // Navigasi ke halaman "DashboardPage"
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => DashboardPage(),
      //         ),
      //       );
      //     }
      //     if (index == 2) {
      //       // Navigasi ke halaman "DashboardPage"
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
      //       // Navigasi ke halaman "AkunPage"
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
