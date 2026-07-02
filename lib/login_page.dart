import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_id/android_id.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as location_package;

import 'auth_state.dart';
import 'components/actionComponent.dart';
import 'components/loadingComponent.dart';
import 'dataAbsenOffline_page.dart';
import 'components/menu.dart';
import 'package:garamina/services/api_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DateTime dateTime = DateTime.now();
  bool _isObscured = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool checkedValue = false;
  String? macAddress;
  String? absenDataString;
  String? username;
  String? password;
  int? notifCount;

  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];
  static const platform = MethodChannel('developer_mode');
  bool devMod = false;

  @override
  void initState() {
    super.initState();
    getMacAddress();
    usernamePassword();
    _ambilDanSimpanLokasi();
    // showFloatingNotification();
  }

  Future<void> isDeveloperModeEnabled() async {
    try {
      final bool result = await platform.invokeMethod('isDeveloperModeEnabled');
      if (result) {
        showErrorDialog(
            'Garamina mobile tidak mengizinkan anda menghidupkan opsi developer!!!');
      } else {
        _login();
      }
      setState(() {
        devMod = result;
      });
    } on PlatformException catch (e) {
      print("Error: '${e.message}'.");
    }
  }

  Future<void> _ambilDanSimpanLokasi() async {
    try {
      if (await location_package.Location().hasPermission() !=
          location_package.PermissionStatus.granted) {
        print("Izin lokasi tidak diberikan. Mungkin menggunakan fake GPS.");
        return;
      }

      location_package.LocationData locationData =
          await location_package.Location().getLocation();

      await _simpanLokasiKeSharedPreferences(
        locationData.latitude ?? 0.0,
        locationData.longitude ?? 0.0,
      );

      print("Lokasi: ${locationData.latitude}, ${locationData.longitude}");
    } catch (e) {
      print("Error saat mengambil lokasi: $e");
    }
  }

  Future<void> _simpanLokasiKeSharedPreferences(
      double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('berhasil disimpan: $latitude');
    prefs.setDouble('lastLocationLatitude', latitude);
    prefs.setDouble('lastLocationLongitude', longitude);
  }

  void showFloatingNotification() {
    Fluttertoast.showToast(
      msg: "Ini adalah notifikasi mengapung",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  getMacAddress() async {
    const _androidIdPlugin = AndroidId();
    if (Platform.isAndroid) {
      final String? androidId = await _androidIdPlugin.getId();
      print(androidId);
      macAddress = androidId.toString();
    } else if (Platform.isIOS) {
      print("Not available on iOS");
    } else {
      print("Not available on this platform");
    }
  }

  Future<void> _setPreference(
      costCenter,
      idPeg,
      namaUser,
      nik,
      costid,
      idLokasi,
      lokasi,
      status,
      foto,
      foto_pengumuman,
      username,
      password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (checkedValue) {
      print('data masuk $username');
      prefs.setString('username', username.toString());
      prefs.setString('password', password.toString());
      prefs.setString('checkedValue', 'true');
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.remove('checkedValue');
    }
    if (prefs.getString('idPeg') != null) {
      print('id peg kosong');
      sinkronisasi();
    } else {
      print('id peg tidak kosong');
      prefs.setString('costCenter', costCenter.toString());
      prefs.setString('idPeg', idPeg.toString());
      prefs.setString('namaUser', namaUser.toString());
      prefs.setString('nik', nik.toString());

      // tambahan
      // prefs.setString('costid',costid.toString());
      // prefs.setString('idLokasi',idLokasi.toString());
      // prefs.setString('lokasi',lokasi.toString());
      // prefs.setString('status',status.toString());
      // prefs.setString('foto',foto.toString());
      // prefs.setString('foto_pengumuman',foto_pengumuman.toString());
      //
      // print(prefs.getString('costCenter'));
      // print(prefs.getString('status'));
      // print(prefs.getString('foto_pengumuman'));
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    final username = _usernameController.text;
    final password = _passwordController.text;
    try {
      final response = await http.post(
        Uri.parse(
            ApiServices.login),
        headers: {
          'APIKEY': ApiServices.apiKey,
        },
        body: {
          'username': username,
          'password': password,
          'macAddress': macAddress.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        print(macAddress.toString());

        if (responseData['msg'] == 'Sukses') {
          if (responseData['status_macAddress'] == 'true') {
            await getDataNotif(responseData['idPeg']);
            _setPreference(
                responseData['costCenter'],
                responseData['idPeg'],
                responseData['namaUser'],
                responseData['nik'],
                responseData['costid'],
                responseData['idLokasi'],
                responseData['lokasi'],
                responseData['status'],
                responseData['foto'],
                responseData['foto_pengumuman'],
                username,
                password);

            final authState = Provider.of<AuthState>(context, listen: false);

            authState.setAuthData(
              costCenter: responseData['costCenter'],
              idPeg: responseData['idPeg'],
              namaUser: responseData['namaUser'],
              nik: responseData['nik'],
              costid: responseData['costid'],
              idLokasi: responseData['idLokasi'],
              lokasi: responseData['lokasi'],
              status: responseData['status'],
              foto: responseData['foto'],
              info: responseData['foto_pengumuman'],
              username: username,
              password: password,
              notifCount: notifCount,
            );

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CustomBottomNavBar(),
              ),
            );
          } else {
            showErrorDialog(
                'Anda mencoba mengakses akun yang bukan milik anda. Satu akun hanya bisa dibuka di satu perangkat!.');
          }
        } else {
          showErrorDialog('Username atau password salah. Silakan coba lagi.');
        }
      } else {
        getDataEmergency(username, password);
      }
    } catch (e) {
      showErrorDialog('Periksa koneksi anda lalu coba kembali.');
    }
  }

  void usernamePassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('username') != null
        ? _usernameController.text = prefs.getString('username')!
        : null;

    prefs.getString('password') != null
        ? _passwordController.text = prefs.getString('password')!
        : null;
    prefs.getString('checkedValue') == 'true'
        ? setState(() {
            checkedValue = true;
          })
        : setState(() {
            checkedValue = false;
          });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Gagal'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductWithText(
      path, Color backgroundColor, String text, String descript) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Image.asset(
              path,
              width: 50,
              height: 50,
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: backgroundColor,
                  title: const Text(
                    'Detail Product',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    descript,
                    style: const TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Future<void> sinkronisasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('absenData') != null) {
      print('absenData ada ');
      absenDataString = prefs.getString('absenData');

      final List<dynamic> absenDataList = json.decode(absenDataString!);
      print(absenDataList);
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
      final response = await http.post(
        Uri.parse(
            ApiServices.insertAbsenEmergencyLogin),
        headers: {
          'APIKEY': ApiServices.apiKey,
          'Content-Type': 'application/json',
        },
        body: absenDataList.toString(),
      );
      final test = json.decode(response.body);
      print('status response: ${response.statusCode.toString()}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('test sinkronisasi $responseData');
        if (responseData[0]['status'] == true) {
          await prefs.remove('absenData');
        } else {
          showErrorDialog(
              'Terdapat data emergency yang tidak bisa di sinkronisasi!');
        }
      } else {
        showErrorDialog('Server masih maintenance');
      }
    } else {
      print('no data absen');
    }
  }

  Future<void> updateStatusEmergency(idPeg, checkStatus) async {
    try {
      final response = await http.post(
        Uri.parse(
            ApiServices.updateCheckStatus),
        headers: {
          'APIKEY': ApiServices.apiKeyPtGaram,
        },
        body: {
          'idPeg': idPeg.toString(),
          'checkStatus': checkStatus.toString(),
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

  Future<void> setPreferenceEmergency(costCenter, idPeg, namaUser, nik,
      check_status, check_shift_M, koordinat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('costCenter', costCenter.toString());
    prefs.setString('idPeg', idPeg.toString());
    prefs.setString('namaUser', namaUser.toString());
    prefs.setString('nik', nik.toString());
    prefs.setString('checkStatus', check_status.toString());
    prefs.setString('checkShiftM', check_shift_M.toString());
    prefs.setString('koordinat', koordinat.toString());
  }

  Future<void> getDataEmergency(username, password) async {
    try {
      final response = await http.post(
        Uri.parse(
            ApiServices.getStatusAbsen),
        headers: {
          'APIKEY': ApiServices.apiKeyPtGaram,
        },
        body: {
          'userName': username.toString(),
          'password': password.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        if (responseData[0]['checkStatus'] == 'A-A' ||
            responseData[0]['checkStatus'] == 'A-') {
          DateTime tanggalDariResponse =
              DateTime.parse(responseData[0]['tanggalAbsen']);

          bool bedaHari = tanggalDariResponse.difference(dateTime).inDays != 0;
          if (bedaHari) {
            updateStatusEmergency(responseData[0]['idPeg'], '0-0');
            setPreferenceEmergency(
                responseData[0]['costCenter'],
                responseData[0]['idPeg'],
                responseData[0]['namaUser'],
                responseData[0]['nik'],
                '0-0',
                responseData[0]['checkShiftM'],
                responseData[0]['koordinat']);
          } else {
            setPreferenceEmergency(
                responseData[0]['costCenter'],
                responseData[0]['idPeg'],
                responseData[0]['namaUser'],
                responseData[0]['nik'],
                responseData[0]['checkStatus'],
                responseData[0]['checkShiftM'],
                responseData[0]['koordinat']);
          }
        } else {
          setPreferenceEmergency(
              responseData[0]['costCenter'],
              responseData[0]['idPeg'],
              responseData[0]['namaUser'],
              responseData[0]['nik'],
              responseData[0]['checkStatus'],
              responseData[0]['checkShiftM'],
              responseData[0]['koordinat']);
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Peringatan"),
              content: const Text(
                  "Server sedang maintenace, anda diperbolehkan melakukan absen darurat!!"),
              actions: <Widget>[
                TextButton(
                  child: const Text('Oke'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DataAbsenOfflinePage(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  getDataNotif(empId) async {
    try {
      final response = await http.post(
        Uri.parse(
            ApiServices.listLonceng),
        headers: {
          'APIKEY': ApiServices.apiKey,
        },
        body: {
          'empId': empId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        print(responseData.length);
        setState(() {
          notifCount = responseData.length;
        });

        print('setelah diupdate $notifCount');
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _isLoading == true
              ? LoadingComponent()
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 150,
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                const SizedBox(height: 40),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TextField(
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Username',
                                      prefixIcon: Icon(Icons.person),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TextField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isObscured = !_isObscured;
                                          });
                                        },
                                        icon: Icon(
                                          _isObscured
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                    obscureText: _isObscured,
                                  ),
                                ),
                                CheckboxListTile(
                                  title:
                                      const Text("Simpan username & password"),
                                  value: checkedValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      checkedValue = newValue!;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _login();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('Login'),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                const Divider(),
                                const Text(
                                  "Products",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    _buildProductWithText(
                                        'assets/img/produk/lososa.png',
                                        Colors.blue,
                                        'Lososa',
                                        'LoSoSa adalah garam alami kualitas prima dengan kandungan Sodium rendah (60% NaCl) dibanding dengan garam dapur biasa. LoSoSa juga diperkaya dengan 40 ppm Iodium lebih tinggi dari ketentuan minimal 30 ppm.'),
                                    _buildProductWithText(
                                        'assets/img/produk/magisa3.png',
                                        Colors.green,
                                        'Magisa',
                                        'Magisa merupakan cairan pencuci buah dan sayur berbahan dasar garam. Garam merupakan salah satu bahan alami yang dapat digunakan untuk membersihkan mikroba serta pestisida pada buah atau sayur yang kita konsumsi.'),
                                    _buildProductWithText(
                                        'assets/img/produk/segitiga3.png',
                                        Colors.orange,
                                        'Segitiga G',
                                        'Segitiga G Garam merupakan garam produksi yang diproses dengan menggunakan teknologi pengolahan yang menjamin higenitas produk dan kandungan yodium yang cukup, sehingga dapat membantu mencegah terjadinya penyakit gondok, kretin dan penurunan IQ serta menambah rasa lezat pada makanan.'),
                                    _buildProductWithText(
                                        'assets/img/produk/therapina.png',
                                        Colors.purple,
                                        'Therapina',
                                        'Therapina artisanal salt spa adalah produk yang berguna membantu menutrisi dan melembutkan kulit dengan sensasi exfoliating mengangkat kulit mati sekaligus relaksasi tubuh yang lelah.'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ============================= WARNING ===============================
                        // KODE INI MENYANGKUT LISENSI, HAK CIPTA dan Hak Kekayaan Intelektual
                        // Siapapun terlarang menghapus kode ini tanpa sepengetahuan developer
                        const Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Made with ❤ by. Bagus Untoro',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        // ======================================================================
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
