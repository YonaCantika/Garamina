import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_state.dart';
import 'absen_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'location/location_service.dart';
import 'location/user_location.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator

class AbsenPage extends StatefulWidget {
  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  LocationService locationService = LocationService();
  String? selectedCondition = 'Semangat';
  TextEditingController descriptionController = TextEditingController();
  File? imageFile; // Menyimpan gambar yang diambil dari kamera
  double? distanceToKantor; // Menyimpan jarak ke kantor

  @override
  void dispose() {
    locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final absenState = Provider.of<AbsenState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Absen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<UserLocation>(
              stream: locationService.locationStream,
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
                  distanceToKantor = distance / 1000; // Jarak dalam kilometer
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Jarak ke Kantor: ${distanceToKantor! <= 0.09 ? "0.0km anda bisa absen!" : distanceToKantor!.toStringAsFixed(2) +"km, anda belum bisa absen!"}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Container(
                        height: 150, // Sesuaikan dengan kebutuhan
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(kantorCoordinates.latitude, kantorCoordinates.longitude),
                            zoom: 15, // Tingkat zoom awal
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
                            // Jika Anda memerlukan pengendalian peta, Anda dapat melakukannya di sini
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
            DropdownButton<String>(
              value: selectedCondition,
              onChanged: (newValue) {
                setState(() {
                  selectedCondition = newValue;
                });
              },
              items: <String>['Semangat', 'Sedih', 'Gembira', 'Tertekan', 'Nyaman', 'Boring']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      // Tambahkan ikon di sini
                      Icon(Icons.star), // Ganti dengan ikon yang sesuai
                      SizedBox(width: 8), // Beri sedikit spasi antara ikon dan teks
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
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

    // Kirim data absen ke server sesuai dengan kebutuhan

    setState(() {
      imageFile = null;
      descriptionController.clear();
      selectedCondition = 'Semangat';
    });
  }
}
