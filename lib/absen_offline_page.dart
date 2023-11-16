import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'components/actionComponent.dart';
import 'location/location_service.dart';
import 'location/user_location.dart';
import 'dataAbsenOffline_page.dart';

class AbsenOfflinePage extends StatefulWidget {
  @override
  _AbsenOfflinePageState createState() => _AbsenOfflinePageState();
}

class _AbsenOfflinePageState extends State<AbsenOfflinePage> {
  LocationService? locationService;
  String? selectedCondition = 'semangat';
  final descriptionController = TextEditingController();
  File? imageFile;
  double? distanceToKantor;
  String? koordinatUser;
  String? alamatLengkap;
  DateTime? dateTime;
  bool isLoading = false;
  bool valid = false;
  // final player = AudioPlayer();


  //safe device
  bool isJailBroken = false;
  bool canMockLocation = false;
  bool isRealDevice = true;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isDevelopmentModeEnable = false;

  String? idPeg;
  String? namaUser;
  String? checkStatus;
  String? checkShiftM;
  String? koordinat;

  @override
  void dispose() {
    locationService?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    locationService = LocationService();
    initPlatformState();
    getDataFromSharedPreferences();
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mengambil nilai dengan kunci tertentu
    setState(() {
      idPeg = prefs.getString('idPeg');
      namaUser = prefs.getString('namaUser');
      checkStatus = prefs.getString('checkStatus');
      checkShiftM = prefs.getString('checkShiftM');
      koordinat = prefs.getString('koordinat');
    });

  }

  Future<void> initPlatformState() async {
    await Permission.location.request();
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }

    if (!mounted) return;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      canMockLocation = await SafeDevice.canMockLocation;
      isRealDevice = await SafeDevice.isRealDevice;
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      isSafeDevice = await SafeDevice.isSafeDevice;
      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    } catch (error) {
      print(error);
    }

    setState(() {
      isJailBroken = isJailBroken;
      canMockLocation = canMockLocation;
      isRealDevice = isRealDevice;
      isOnExternalStorage = isOnExternalStorage;
      isSafeDevice = isSafeDevice;
      isDevelopmentModeEnable = isDevelopmentModeEnable;
    });
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Absen'),
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
      body:
      isLoading == true ?
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/img/bg.png'), // Background image
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
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              StreamBuilder<UserLocation>(
                stream: locationService?.locationStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final userLocation = snapshot.data!;

                    // alamat = alamat dari userLocation
                    koordinatUser = '${userLocation.latitude},${userLocation.longitude}';
                    final kantorLocation = koordinat ?? '';
                    final kantorCoordinates = LatLng(
                      double.parse(kantorLocation.split(',')[0]),
                      double.parse(kantorLocation.split(',')[1]),
                    );

                    final lat1 = userLocation.latitude;
                    final lon1 = userLocation.longitude;
                    final lat2 = kantorCoordinates.latitude;
                    final lon2 = kantorCoordinates.longitude;

                    // Fungsi sederhana untuk menghitung jarak antara dua titik
                    double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
                      const int earthRadius = 6371; // Radius of the Earth in kilometers

                      // Menghitung perbedaan garis lintang dan garis bujur
                      final latDistance = (lat2 - lat1).abs();
                      final lonDistance = (lon2 - lon1).abs();

                      // Menggunakan rumus Pythagoras untuk menghitung jarak
                      final distance = sqrt(
                          pow(latDistance, 2) + pow(lonDistance, 2)
                      ) * (earthRadius * pi / 180);

                      return distance;
                    }

                    final distance = calculateDistance(lat1, lon1, lat2, lon2);
                    distanceToKantor = distance;


                    // Menggunakan Geocoding untuk mengonversi koordinat menjadi alamat
                    Future<void> getAddress() async {
                      try {
                        final List<Placemark> placemarks = await placemarkFromCoordinates(
                          userLocation.latitude,
                          userLocation.longitude,
                        );

                        // if (placemarks.isNotEmpty) {
                        final Placemark placemark = placemarks[0];
                        final String alamat = placemark.street ?? '';
                        final String kota = placemark.locality ?? '';
                        final String provinsi = placemark.administrativeArea ?? '';

                        // Sekarang Anda memiliki alamat dari koordinat
                        alamatLengkap = '$alamat, $kota, $provinsi';

                        // Update tampilan jika alamat berhasil diambil
                        setState(() {});

                      } catch (e) {
                        // Tangani kesalahan jika tidak dapat mengambil alamat
                        print('Kesalahan saat mengambil alamat: $e');
                      }
                    }

                    getAddress();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (canMockLocation)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Anda menggunakan fake GPS',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[900],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Anda bisa absen dari mana saja di menu emergency!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(kantorCoordinates.latitude, kantorCoordinates.longitude),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('absen_location'),
                                position: LatLng(kantorCoordinates.latitude, kantorCoordinates.longitude),
                                infoWindow: const InfoWindow(title: 'Lokasi Absen'),
                              ),
                              Marker(
                                markerId: const MarkerId('user_location'),
                                position: LatLng(userLocation.latitude, userLocation.longitude),
                                infoWindow: const InfoWindow(title: 'Lokasi Anda'),
                              ),
                            },
                            onMapCreated: (GoogleMapController controller) {
                              // Pengendalian peta jika diperlukan
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 20),
              imageFile != null ?
              // menampilkan hasil gambar
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (imageFile != null)
                    Image.file(
                      imageFile!,
                      height: 150,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                ],
              ):
              // tombol kamera
              SizedBox(
                width: double
                    .infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed:(){
                    _getImageFromCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    primary: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.camera),
                  label: const Text(
                    'Ambil gambar',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // rata kanan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // input deskripsi
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan deskripsi pekerjaan',
                    ),
                  ),
                  const SizedBox(height: 20),

                  //input kondisi
                  const Text(
                    'Kondisi Saat Ini:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      _buildConditionBox('Semangat😎', 'semangat'),
                      _buildConditionBox('Sedih😭', 'sedih'),
                      _buildConditionBox('Gembira😆', 'gembira'),
                      _buildConditionBox('Tertekan😥', 'tertekan'),
                      _buildConditionBox('Nyaman😊', 'nyaman'),
                      _buildConditionBox('Boring😶', 'boring'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(

                  onPressed: checkStatus == '0-0' || checkStatus != '0-0' ? () {
                    setState(() {
                      isLoading = true;
                    });
                    initPlatformState();
                    _saveAbsenData(
                      // absenState.checkStatus,
                        checkStatus,
                      // authState.idPeg,
                      idPeg,
                      descriptionController,
                      imageFile,
                      // absenState.checkShiftM,
                        checkShiftM,
                      selectedCondition,
                      // authState.namaUser,
                        namaUser
                    );
                  } : null, // Jika tidak sesuai, maka nilai onPressed diset null
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Tentukan warna berdasarkan nilai absenState.check_status
                    primary: checkStatus == '0-0' ? Colors.blue :
                    checkStatus != '0-0' && checkStatus != 'A-A' ? Colors.red :
                    Colors.grey, // Jika selain itu, gunakan warna abu-abu
                  ),
                  // Tampilkan label sesuai dengan nilai absenState.check_status
                  child: Text(
                    checkStatus == '0-0' ? 'Masuk' :
                    checkStatus != '0-0' && checkStatus != 'A-A'  ? 'Pulang' :
                    'Anda sudah absen pulang',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  void _getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File originalFile = File(pickedFile.path);

      // Load gambar dari path file
      final originalImage = img.decodeImage(originalFile.readAsBytesSync());

      // Membalik gambar secara horizontal jika diambil dengan kamera depan
      final img.Image flippedImage = img.flipHorizontal(originalImage!);

      // Simpan gambar yang sudah dibalik ke file baru
      final File flippedFile = File(pickedFile.path.replaceFirst('.jpg', '_flipped.jpg'))
        ..writeAsBytesSync(img.encodeJpg(flippedImage));

      setState(() {
        imageFile = flippedFile;
        valid = true;
      });


      // setState(() {
      //   imageFile = File(pickedFile.path);
      //   valid = true;
      // });
    }
  }

  void _saveAbsenData(status, empId, note, foto, shift, condition, nama) async {
    // audioCache.play('audio/test.mp3');
    // await player.play(UrlSource('audio/test.mp3'));
    if (valid == false || descriptionController.text.isEmpty) {
      _showErrorDialog('Data Tidak Lengkap',
          'Maaf, Anda tidak dapat melakukan absen karena anda belum melengkapi data.');
      return;
    }

    if (canMockLocation) {
      _showErrorDialog('Perangkat Anda Terdeteksi Fake GPS',
          'Maaf, Anda tidak dapat melakukan absen karena perangkat Anda terdeteksi menggunakan Fake GPS.');
      return;
    }
    if(isRealDevice==false){
      _showErrorDialog('Perangkat Anda Terdeteksi Fake Device',
          'Maaf, Anda tidak dapat melakukan absen karena Anda terdeteksi menggunakan perangkat palsu.');
      return;
    }
    // if(isSafeDevice==true){
    //   _showErrorDialog('Perangkat Anda Tidak Aman',
    //       'Maaf, Anda tidak dapat melakukan absen karena Anda terdeteksi menggunakan perangkat yang tidak aman.');
    //   return;
    // }



    DateTime dateTime = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? absenDataString = prefs.getString('absenData');
    List<Map<String, dynamic>> absenDataList = [];

    if (absenDataString != null) {
      // prefs.remove('absenData');
      final List<dynamic> absenListJson = json.decode(absenDataString);
      print(absenListJson.length);
      print(absenListJson);

      // cek absenListJson adalah daftar JSON
      if (absenListJson is List) {
        // Decode data JSON dari string dalam elemen daftar
        absenListJson.forEach((element) {
          // Decode elemen dan konversi ke Map<String, dynamic>
          final Map<String, dynamic>? absenMap = json.decode(element);

          // Pastikan bahwa data yang di-decode adalah Map
          if (absenMap != null) {
            absenDataList.add(absenMap);
          } else {
            print('Gagal mengkonversi elemen JSON: $element');
          }
        });
      }
    }

    // Load gambar dari path file
    final image = img.decodeImage(File(foto.path).readAsBytesSync());

    // Menentukan lebar dan tinggi
    final int desiredWidth = 400;
    final int desiredHeight = 300;

    // Memperkecil gambar
    final img.Image resizedImage = img.copyResize(image!, width: desiredWidth, height: desiredHeight);

    // Mengatur kualitas gambar
    final File compressedFile = File(foto.path)..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 60));

    // Mencari mimeTypeData untuk file yang sudah diperkecil
    final mimeTypeData = lookupMimeType(compressedFile.path, headerBytes: [0xFF, 0xD8]);

    // Buat MultipartFile dari file yang sudah diperkecil
    final file = await http.MultipartFile.fromPath('foto', compressedFile.path, contentType: MediaType.parse(mimeTypeData!));

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/foto${dateTime.toIso8601String()}.jpg';

    try {
      // Cek apakah file foto ada sebelum mencoba menyalinnya
      if (await compressedFile.exists()) {
        await compressedFile.copy(imagePath);
        print('Gambar berhasil disalin ke: $imagePath');
      } else {
        print('File foto tidak ditemukan');
      }
    } catch (e) {
      print('Error saat menyalin gambar: $e');
    }


    // Untuk menambahkan data absen baru ke dalam daftar
    final Map<String, dynamic> newAbsenData = {
      'status': checkShiftM == true ? 'out_morning' : status == '0-0' ? 'in' : 'out',
      'empId': empId,
      'shift': 'A',
      'note': note.text,
      'koordinat': koordinatUser!,
      'datetime': dateTime.toIso8601String(),
      'emoticon': condition,
      'jarak': '0.0',
      'alamat': alamatLengkap ?? '',
      'foto' : imagePath,
    };

    // Mengkonversi string dateTime currentime
    TimeOfDay currentTime = TimeOfDay.fromDateTime(dateTime);

    // Membuat targetTime pada jam 18:00
    TimeOfDay targetTime = TimeOfDay(hour: 18, minute: 0);

    // Membandingkan currentTime dengan targetTime
    if (currentTime.hour > targetTime.hour || (currentTime.hour == targetTime.hour && currentTime.minute > targetTime.minute)) {
      if(status == '0-0'){
        await prefs.setString('checkShiftM', 'true');
        print("out_morning");
      }
    }else{
      await prefs.setString('checkShiftM', 'false');
    }

    absenDataList.add(newAbsenData);

    // Simpan kembali data absen yang sudah diperbarui
    final List<String> absenListJson = absenDataList.map((absenData) => json.encode(absenData)).toList();
    prefs.setString('absenData', json.encode(absenListJson));

    status == '0-0' ?
    await prefs.setString('checkStatus', 'A-') : status == 'A-' ?
    await prefs.setString('checkStatus', '0-0') : null;

    setState(() {
      isLoading = false;
    });
    _showSuccessDialog(nama, status, condition, koordinatUser!, alamatLengkap!, dateTime, foto, 'Absen Darurat', 'Kerja kita prestasi bersama');
    setState(() {
      imageFile = null;
      descriptionController.clear();
      selectedCondition = 'Semangat';

    });


  }


  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
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
    setState(() {
      isLoading = false;
    });
  }

  void _showSuccessDialog(
      String nama, String status, String condition, String koordinat, String alamat, DateTime dateTime, foto, judul, slogan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${judul}'),
          content: Column(
            children: [
              if (foto != null)
                Image.file(
                  foto!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
              Text('Nama: $nama'),
              Text('Absen: ${status == '0-0' ? 'Masuk' : 'Pulang'}'),
              Text('Kondisi: $condition'),
              Text('Koordinat: $koordinat'),
              Text('Alamat: $alamat'),
              Text('Date Time: ${dateTime.toIso8601String()}'),
              Text('Slogan: ${slogan}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
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
  }


  Widget _buildConditionBox(String condition, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCondition = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedCondition == value ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          condition,
          style: TextStyle(
            fontSize: 16,
            color: selectedCondition == value ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }
}
