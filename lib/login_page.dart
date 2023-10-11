import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'auth_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';

import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Fungsi untuk melakukan login
  Future<void> _login() async {
    // Set _isLoading menjadi true saat permintaan HTTP dimulai
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://garamina.com/fintech2/integrasi/android/login/login'),
        headers: {
          'APIKEY': '8deca313c70c6195eba4208b8dc6d56b',
        },
        body: {
          'username': username,
          'password': password,
        },
      );


      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['msg'] == 'Sukses') {
          // Login berhasil, simpan data ke AuthState
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

        } else {
          // Login gagal, tampilkan pesan kesalahan
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Login Gagal'),
                content:
                Text('Username atau password salah. Silakan coba lagi.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle respons selain status code 200 sesuai kebutuhan
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login Gagal'),
              content:
              Text('Server bermasalah, silahkan hubungi admin!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }

    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Gagal'),
            content:
            Text('Periksa koneksi anda lalu coba kembali.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Stack(
        children: [
          _isLoading == true ?
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg.png'), // Background image
                fit: BoxFit.cover, // Sesuaikan ukuran gambar dengan konten
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.7), // Warna efek putih dengan opasitas 0.7 (untuk penyesuaian)
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg.png'), // Background image
                fit: BoxFit.cover, // Sesuaikan ukuran gambar dengan konten
              ),
            ),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Tambahkan logo di atas form
                  Image.asset(
                    'assets/img/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 40), // Spasi antara logo dan form
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
                          // Form login
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
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
                                border: OutlineInputBorder(),
                              ),
                              obscureText: _isObscured,
                            ),
                          ),
                          SizedBox(
                              height: 20), // Spasi antara password dan tombol login
                          SizedBox(
                            width: double
                                .infinity, // Membuat tombol login memenuhi lebar
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                              _isLoading ? null : _login, // Disable tombol saat _isLoading adalah true
                              child: _isLoading
                                  ? Center(
                                child: Image.asset(
                                  'assets/img/loader.gif', // Path ke gambar GIF di aset
                                  width: 25, // Sesuaikan dengan ukuran yang Anda inginkan
                                  height: 25,
                                ),
                              ) // Tampilkan gambar GIF saat _isLoading adalah true
                                  : Text('Login'),
                            ),
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
}
