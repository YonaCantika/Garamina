import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';


import 'auth_state.dart';
import 'dashboard_page.dart';
import 'dataAbsenOffline_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool checkedValue = false;


  // String macAddress = await getMacAddress();

  Future<String> getMacAddress() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo.androidId);
      return androidInfo.androidId;
    } else if (Platform.isIOS) {
      return "Not available on iOS";
    } else {
      return "Not available on this platform";
    }
  }


  Future<void> _setPreference(costCenter, idPeg, namaUser, nik) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('costCenter', costCenter.toString());
    prefs.setString('idPeg', idPeg.toString());
    prefs.setString('namaUser', namaUser.toString());
    prefs.setString('nik',nik.toString());
  }


  // Fungsi untuk melakukan login
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;
    final macAddress = getMacAddress();
    print(macAddress);

    try {
      final response = await http.post(
        Uri.parse('https://garamina.com/fintech2/integrasi/android/login/login'),
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
        },
        body: {
          'username': username,
          'password': password,
          'macAddress' : macAddress.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);

        if (responseData['msg'] == 'Sukses') {
          if( responseData['status_macAddress'] == 'true'){
            // Login berhasil, simpan data ke Shared Preferences
            _setPreference(
                responseData['costCenter'],
                responseData['idPeg'],
                responseData['namaUser'],
                responseData['nik']
            );

            final authState = Provider.of<AuthState>(context, listen: false);
            authState.setAuthData(
              costCenter: responseData['costCenter'],
              costid: responseData['costid'],
              idLokasi: responseData['idLokasi'],
              idPeg: responseData['idPeg'],
              lokasi: responseData['lokasi'],
              namaUser: responseData['namaUser'],
              nik: responseData['nik'],
              status: responseData['status'],
            );

            // Arahkan ke halaman menu
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DashboardPage(),
              ),
            );
          }else{
            showErrorDialog('Anda mencoba mengakses akun yang bukan milik anda. Satu akun hanya bisa dibuka di satu perangkat!.');
          }
        } else {
          showErrorDialog('Username atau password salah. Silakan coba lagi.');
        }
      } else {
        showErrorDialog('Server bermasalah, silahkan hubungi admin!');
      }
    } catch (e) {
      showErrorDialog('Periksa koneksi anda lalu coba kembali.');
    }
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
                  title: const Text('Detail Product', style: TextStyle(color: Colors.white),),
                  content: Text(descript, style: const TextStyle(color: Colors.white),),
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
                        // Colors.purple
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 5), // Spasi vertikal antara ikon dan teks
        Text(
          text,
          style: TextStyle(fontSize: 12, fontWeight:FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          _isLoading == true ?
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/img/bg.png'), // Background image
                fit: BoxFit.cover, // Sesuaikan ukuran gambar dengan konten
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5), // Warna efek putih dengan opasitas 0.7 (untuk penyesuaian)
                  BlendMode.dstATop, // Mode efek putih
                ),
              ),

            ),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Tambahkan logo di atas form
                  Image.asset(
                    'assets/img/loader.gif',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
          ) :
            Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg.png'), // Background image
                fit: BoxFit.cover, // Sesuaikan ukuran gambar dengan konten
              ),
            ),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 5, // Efek shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("LOGIN",
                            style: TextStyle(fontSize: 26, fontWeight:FontWeight.bold, color: Colors.grey),),
                          const SizedBox(height: 40),
                          // Form login
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                            title: const Text("Simpan username & password"),
                            value: checkedValue,
                            onChanged: (newValue) {
                              setState(() {
                                checkedValue = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          const SizedBox(height: 20),
                          //login button
                          SizedBox(
                            width: double
                                .infinity, // Membuat tombol login memenuhi lebar
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                              _isLoading ? null : _login, // Disable tombol saat _isLoading adalah true
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          //emergency button
                          SizedBox(
                            width: double
                                .infinity, // Membuat tombol login memenuhi lebar
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                              _isLoading ? null :
                              _daruratAbsen
                              // getMacAddress
                              // playAudio
                              ,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                primary: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Emergency'),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Divider(),
                          const Text("Products", style: TextStyle(fontSize: 13, fontWeight:FontWeight.bold, color: Colors.grey),),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _buildProductWithText('assets/img/produk/lososa.png', Colors.blue, 'Lososa', 'LoSoSa adalah garam alami kualitas prima dengan kandungan Sodium rendah (60% NaCl) dibanding dengan garam dapur biasa. LoSoSa juga diperkaya dengan 40 ppm Iodium lebih tinggi dari ketentuan minimal 30 ppm.'),
                              _buildProductWithText('assets/img/produk/magisa3.png', Colors.green, 'Magisa', 'Magisa merupakan cairan pencuci buah dan sayur berbahan dasar garam. Garam merupakan salah satu bahan alami yang dapat digunakan untuk membersihkan mikroba serta pestisida pada buah atau sayur yang kita konsumsi.'),
                              _buildProductWithText('assets/img/produk/segitiga3.png', Colors.orange, 'Segitiga G', 'Segitiga G Garam merupakan garam produksi yang diproses dengan menggunakan teknologi pengolahan yang menjamin higenitas produk dan kandungan yodium yang cukup, sehingga dapat membantu mencegah terjadinya penyakit gondok, kretin dan penurunan IQ serta menambah rasa lezat pada makanan.'),
                              _buildProductWithText('assets/img/produk/therapina.png', Colors.purple, 'Therapina', 'Therapina artisanal salt spa adalah produk yang berguna membantu menutrisi dan melembutkan kulit dengan sensasi exfoliating mengangkat kulit mati sekaligus relaksasi tubuh yang lelah.'),
                            ],
                          ),
                        ],
                      ),
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
  void _daruratAbsen() async{

    // fix version
    // try {
    //   final response = await http.post(
    //     Uri.parse('https://garamina.com/fintech2/integrasi/android/server_aktif/cek'),
    //   );
    //
    //   if (response.statusCode == 200) {
    //     final responseData = json.decode(response.body);
    //
    //     if (responseData['msg'] == 'Sukses') {
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             title: const Text("Server Berfungsi"),
    //             content: const Text("Anda tidak bisa mengakses menu Emergency karena server berfungsi dengan baik!!"),
    //             actions: <Widget>[
    //               TextButton(
    //                 child: const Text('oke'),
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           );
    //         },
    //       );
    //     }
    //   } else {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: const Text("Peringatan"),
    //           content: const Text("Anda akan memasuki menu darurat, fitur ini hanya boleh digunakan ketika server sedang maintenance, penggunaan menu darurat diluar maintenance tidak diperkenankan!!"),
    //           actions: <Widget>[
    //             TextButton(
    //               child: const Text('Lanjutkan'),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //                 Navigator.of(context).push(
    //                   MaterialPageRoute(
    //                     builder: (context) => DataAbsenOfflinePage(),
    //                   ),
    //                 );
    //               },
    //             ),
    //             TextButton(
    //               child: const Text('Batal'),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   }
    // } catch (e) {
    //   showErrorDialog('Periksa koneksi anda lalu coba kembali.');
    // }

   // testing version
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Peringatan"),
          content: const Text("Anda akan memasuki menu darurat, fitur ini hanya boleh digunakan ketika server sedang maintenance, penggunaan menu darurat diluar maintenance tidak diperkenankan!!"),
          actions: <Widget>[
            TextButton(
              child: const Text('Lanjutkan'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DataAbsenOfflinePage(),
                  ),
                );
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
