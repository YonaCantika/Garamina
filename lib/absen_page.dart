import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_state.dart';
import 'absen_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'location/location_service.dart';
import 'location/user_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';

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
  bool canMockLocation = false;

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
  }

  Future<void> initPlatformState() async {
    await Permission.location.request();
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }

    if (!mounted) return;
    try {
      canMockLocation = await SafeDevice.canMockLocation;
    } catch (error) {
      print(error);
    }

    setState(() {
      canMockLocation = canMockLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Anda menggunakan fake GPS',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[900],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Jarak ke Kantor: ${distanceToKantor! <= 0.09 ? "0.0km anda bisa absen!" : distanceToKantor!.toStringAsFixed(2) + "km, anda belum bisa absen!"}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
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
                                markerId: MarkerId('absen_location'),
                                position: LatLng(kantorCoordinates.latitude, kantorCoordinates.longitude),
                                infoWindow: InfoWindow(title: 'Lokasi Absen'),
                              ),
                              Marker(
                                markerId: MarkerId('user_location'),
                                position: LatLng(userLocation.latitude, userLocation.longitude),
                                infoWindow: InfoWindow(title: 'Lokasi Anda'),
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
              ElevatedButton(
                onPressed: () {
                  _saveAbsenData();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Simpan Absen',
                  style: TextStyle(
                    fontSize: 18,
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

  void _saveAbsenData() {
    final String description = descriptionController.text;
    final String condition = selectedCondition ?? '';

    if (canMockLocation) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Perangkat Anda Terdeteksi Fake GPS'),
            content: Text('Maaf, Anda tidak dapat melakukan absen karena perangkat Anda terdeteksi menggunakan Fake GPS.'),
            actions: <Widget>[
              TextButton(
                child: Text('Tutup'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Lanjutkan dengan pengiriman data absen ke server
      // ...

      setState(() {
        imageFile = null;
        descriptionController.clear();
        selectedCondition = 'Semangat';
      });
    }
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
