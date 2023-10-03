import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'location/location_service.dart';
import 'location/user_location.dart';
import 'auth_state.dart';
import 'absen_state.dart';
import 'dataAbsen_page.dart';


class AbsenPage extends StatefulWidget {
  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  LocationService? locationService;
  String? selectedCondition = 'Semangat';
  TextEditingController descriptionController = TextEditingController();
  File? imageFile;
  double? distanceToKantor;
  String? koordinatUser;
  String? alamatLengkap;
  DateTime? dateTime;


  //safe device
  bool isJailBroken = false;
  bool canMockLocation = false;
  bool isRealDevice = true;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isDevelopmentModeEnable = false;

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
    // getAddress();
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
    final authState = Provider.of<AuthState>(context);
    final absenState = Provider.of<AbsenState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Absen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<UserLocation>(
                stream: locationService?.locationStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final userLocation = snapshot.data!;
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
                    // alamat = alamat dari userLocation
                    koordinatUser = userLocation.latitude.toString()+','+userLocation.longitude.toString();
                    final kantorLocation = absenState.koordinat ?? '';
                    final kantorCoordinates = LatLng(
                      double.parse(kantorLocation.split(',')[0]),
                      double.parse(kantorLocation.split(',')[1]),
                    );
                    final distance = Geolocator.distanceBetween(
                      userLocation.latitude,
                      userLocation.longitude,
                      kantorCoordinates.latitude,
                      kantorCoordinates.longitude,
                    );
                    distanceToKantor = distance / 1000;
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
                          child: Text(
                            'Jarak ke Kantor: ${distanceToKantor! <= 0.09 ? "0.0km anda bisa absen!" : distanceToKantor!.toStringAsFixed(2) + "km, anda belum bisa absen!"}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
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
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _getImageFromCamera();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.camera),
                label: Text(
                  'Ambil Gambar',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (imageFile != null)
                Image.file(
                  imageFile!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 20),
              Text(
                'Deskripsi:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi pekerjaan',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Kondisi Saat Ini:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                children: <Widget>[
                  _buildConditionBox('Semangat'),
                  _buildConditionBox('Sedih'),
                  _buildConditionBox('Gembira'),
                  _buildConditionBox('Tertekan'),
                  _buildConditionBox('Nyaman'),
                  _buildConditionBox('Boring'),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(

                  onPressed: absenState.checkStatus == '0-0' || absenState.checkStatus != '0-0' && absenState.checkStatus != 'A-A' ? () {

                    _saveAbsenData(
                      absenState.checkStatus,
                      authState.idPeg,
                      descriptionController,
                      imageFile,
                      absenState.checkShiftM,
                      selectedCondition,
                      authState.namaUser,
                    );
                  } : null, // Jika tidak sesuai, maka nilai onPressed diset null
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Tentukan warna berdasarkan nilai absenState.check_status
                    primary: absenState.checkStatus == '0-0' ? Colors.blue :
                    absenState.checkStatus != '0-0' && absenState.checkStatus != 'A-A' ? Colors.red :
                    Colors.grey, // Jika selain itu, gunakan warna abu-abu
                  ),
                  // Tampilkan label sesuai dengan nilai absenState.check_status
                  child: Text(
                    absenState.checkStatus == '0-0' ? 'Masuk' :
                    absenState.checkStatus != '0-0' && absenState.checkStatus != 'A-A'  ? 'Pulang' :
                    'Anda sudah absen pulang',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }

  void _getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveAbsenData(status, empId, note, foto, shift, condition, nama) async {

    // if(status.isEmpty || empId.isEmpty || note.isEmpty || foto.isEmpty || shift.isEmpty || condition.isEmpty){
    //   _showErrorDialog('Data tidak lengkap',
    //       'Maaf, Anda tidak dapat melakukan absen karena ada data yang belum anda isi.');
    //   return;
    // }

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

    if(isSafeDevice==false){
      _showErrorDialog('Perangkat Anda Tidak Aman',
          'Maaf, Anda tidak dapat melakukan absen karena Anda terdeteksi menggunakan perangkat yang tidak aman.');
      return;
    }

    if (distanceToKantor! <= 0.09) {
      DateTime dateTime = DateTime.now();

      // Buat request multipart/form-data
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://garamina.com/fintech2/integrasi/android/insert_absen/login'),
      );

      // Tambahkan data form
      request.fields['status'] = status == '0-0' ? 'in' : 'out';
      request.fields['empId'] = empId.toString();
      request.fields['shift'] = 'A';
      request.fields['note'] = note.text;
      request.fields['koordinat'] = koordinatUser!;
      request.fields['datetime'] = dateTime.toIso8601String();
      request.fields['emoticon'] = condition;
      request.fields['jarak'] = '0.0';
      request.fields['alamat'] = alamatLengkap ?? '';

      // Tambahkan file foto
      final mimeTypeData = lookupMimeType(foto.path, headerBytes: [0xFF, 0xD8]);
      final file = await http.MultipartFile.fromPath('foto', foto.path,
          contentType: MediaType.parse(mimeTypeData!));

      request.files.add(file);

      // Kirim permintaan
      final response = await request.send();

      // Tangani respons
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();

        final parsedData = json.decode(responseData);

        if (parsedData['status'] == true) {
          _showSuccessDialog(nama, status, condition, koordinatUser!, alamatLengkap!, dateTime, foto, parsedData['judul'], parsedData['slogan']);
          setState(() {
            imageFile = null;
            descriptionController.clear();
            selectedCondition = 'Semangat';
          });
        } else {
          throw Exception('Gagal: ${parsedData['msg']}');
        }
      } else {
        throw Exception('Gagal: Terjadi kesalahan saat melakukan absen. Silakan coba lagi2.');
      }
    } else {
      _showErrorDialog('Anda berada di luar kantor!!',
          'Maaf, Anda tidak dapat melakukan absen karena lokasi Anda di luar jangkauan.');
      return;
    }
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
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DataAbsenPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
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
              SizedBox(height: 20),
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
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DataAbsenPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildConditionBox(String condition) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCondition = condition;
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedCondition == condition ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          condition,
          style: TextStyle(
            fontSize: 16,
            color: selectedCondition == condition ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }
}
