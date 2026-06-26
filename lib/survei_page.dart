import 'package:flutter/material.dart';
import 'package:garamina/auth_state.dart';
import 'package:garamina/browser_page.dart';
import 'package:garamina/single_choice_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'components/actionComponent.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';
import 'components/customExpandedContainer.dart';
import 'package:garamina/services/api_services.dart';

class SurveiPage extends StatefulWidget {
  @override
  _SurveiPageState createState() => _SurveiPageState();
}

class _SurveiPageState extends State<SurveiPage> {
  // int _selectedIndex = 0;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> surveiData = [];
  bool dataResponseSurvei = false;
  bool loading = true;
  bool noData = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromApi(idPeg) async {
    try {
      final apiUrl = Uri.parse(
          ApiServices.listSurvei);

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        setState(() {
          surveiData = List<Map<String, dynamic>>.from(data);
        });
        if (data['status'] != true || data['status'] != 'true') {
          setState(() {
            noData = true;
          });
        }

        if (data.length > 0) {
          setState(() {
            loading = false;
            dataResponseSurvei = true;
          });
        } else {
          setState(() {
            loading = true;
            dataResponseSurvei = false;
          });
        }
      } else {
        throw Exception(
            'Failed to load data from the API. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        loading = false;
        dataResponseSurvei = false;
      });

      print('Error fetching data from API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    fetchDataFromApi(authState.idPeg);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survei'),
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
          Image.asset(
            'assets/img/dashboard/employee.png',
            height: 200,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomExpandedContainer(
            title: 'List Survei',
            data: surveiData,
            loading: loading,
            dataResponse: dataResponseSurvei,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  noData == true
                      ? const Text('belum survei!!')
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrowserPage(),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text('${surveiData[index]['judul']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Tipe: ${surveiData[index]['tipe_survei']}'),
                                Text(
                                    'Status: ${surveiData[index]['status_survei']}'),
                              ],
                            ),
                            trailing:
                                Text('${surveiData[index]['tanggalSampai']}'),
                          ),
                        ),
                  const Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
