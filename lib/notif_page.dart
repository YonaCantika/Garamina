import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garamina/browser_page.dart';
import 'package:garamina/components/loadingComponent.dart';
import 'package:garamina/survei_page.dart';
import 'package:provider/provider.dart';
import 'auth_state.dart';
import 'components/actionComponent.dart';
import 'package:http/http.dart' as http;

class NotifPage extends StatefulWidget {
  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  // Daftar notifikasi
  List<Map<String, dynamic>> notifications = [];
  int? _notificationCount;
  bool loading = true;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> surveiData = [];
  bool dataResponseDinas = false;

  @override
  void initState() {
    super.initState();
    fetchDataSurvei();
  }

  Future<void> getDataNotif(empId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://garamina.com/fintech2/integrasi/android/lonceng/list_lonceng'),
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
        },
        body: {
          'empId': empId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          notifications = List<Map<String, dynamic>>.from(responseData);
          loading = false;
        });
        final authState = Provider.of<AuthState>(context, listen: false);
        authState.setNotifCount(notifCount: notifications.length);
      } else {
        // Handle jika request tidak berhasil
      }
    } catch (e) {
      // Handle jika terjadi kesalahan
    }
  }

  Future<void> fetchDataSurvei() async {
    try {
      final apiUrl = Uri.parse(
          'http://192.168.1.252/fintech2/integrasi/android/survei/list_survei');

      final response = await http.post(
        apiUrl,
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
        },
        body: {
          'empId': '797',
          'tanggal':
              '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('from survei $data');

        setState(() {
          surveiData = List<Map<String, dynamic>>.from(data);
        });

        if (data.length > 0) {
          setState(() {
            loading = false;
            dataResponseDinas = true;
          });
        } else {
          setState(() {
            loading = false;
            dataResponseDinas = false;
          });
        }
      } else {
        throw Exception(
            'Failed to load data from the API. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        loading = false;
        dataResponseDinas = false;
      });

      print('Error fetching data from API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    getDataNotif(authState.idPeg);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Notifikasi Umum',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 15),
          ),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrowserPage(),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            notifications[index]['namaModul'],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(notifications[index]['msg']),
                          leading: Stack(
                            children: [
                              const Icon(
                                Icons.notifications,
                                size: 30,
                                color: Colors.grey,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      notifications[index]['total'].toString(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Notifikasi Survei',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 15)),
          Expanded(
            child: surveiData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: surveiData.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurveiPage(),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            surveiData[index]['judul'],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(surveiData[index]['tipe_survei']),
                          leading: Stack(
                            children: [
                              const Icon(
                                Icons.notifications,
                                size: 30,
                                color: Colors.grey,
                              ),
                              // Positioned(
                              //     top: 0,
                              //     right: 0,
                              //     child: Container(
                              //       padding: const EdgeInsets.all(2),
                              //       decoration: BoxDecoration(
                              //         color: Colors.red,
                              //         borderRadius: BorderRadius.circular(8),
                              //       ),
                              //       child: Text(
                              //         surveiData[index]['total'].toString(),
                              //         style: const TextStyle(
                              //           fontSize: 11,
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
