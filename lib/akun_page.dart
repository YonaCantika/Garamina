import 'package:flutter/material.dart';
import 'package:garamina/login_page.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';


import 'components/actionComponent.dart';

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String? file = 'null';
  var picked;

  @override
  void initState() {
    super.initState();
  }

  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
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
          Container(
            color: Colors.blue,
            height: 100,
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                'Profil Karyawan',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Bagian 2: Circle Avatar dengan sedikit spasi di bawahnya
          GestureDetector(
            child: SizedBox(
              height: 170, // Sesuaikan tinggi Circle Avatar sesuai kebutuhan Anda
              child: Column(
                children: [
                  authState.foto != 'default.png' ?
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 10, color: Colors.yellowAccent, spreadRadius: 5)],
                    ),
                    child: CircleAvatar(
                      radius:
                      75,
                      backgroundColor:
                      Colors.blue, // Warna latar belakang lingkaran
                      child: ClipOval(
                        child: Image.network(
                          authState.foto.toString(),
                          width: 135,
                          height: 135,
                          fit: BoxFit
                              .cover,
                        ),
                      ),
                    ),
                  ) :
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.yellowAccent,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 10, color: Colors.orange, spreadRadius: 5)],
                    ),
                    child: CircleAvatar(
                      radius:
                      75,
                      backgroundColor:
                      Colors.blue, // Warna latar belakang lingkaran
                      child: ClipOval(
                        child: Image.asset(
                          'assets/img/profile/${authState.foto.toString()}',
                          width:
                          135, // Sesuaikan lebar gambar sesuai kebutuhan Anda
                          height:
                          135, // Sesuaikan tinggi gambar sesuai kebutuhan Anda
                          fit: BoxFit
                              .cover, // Sesuaikan tampilan gambar sesuai kebutuhan Anda
                        ),
                      ),
                    ),
                  ),
                  // Tambahkan spasi di bawah CircleAvatar
                ],
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 0.8, // Sesuaikan faktor tinggi modal
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Update Foto Profil',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 50,),
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
                                child: const Text('Pilih Foto'),
                              ),
                            ) :
                            Text('Foto: ${file!}', style: const TextStyle(fontStyle: FontStyle.italic),),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // _sendDataCuti(authState.idPeg, authState.nik);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Simpan'),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),


          // Bagian 3: ListView dengan Border Radius di Atas
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Judul "Data Karyawan"
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Data Karyawan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0), // Padding sebelah kiri
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            const Text(
                              'Nama Karyawan:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.namaUser ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'NIK:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.nik ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Cost Center:',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authState.costCenter ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double
                                .infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Peringatan'),
                                      content: const Text('Semua data yang tersimpan di local akan dihapus!!'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Batal'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Oke'),
                                          onPressed: () {
                                            clearSharedPreferences();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => LoginPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
