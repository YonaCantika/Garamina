import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_state.dart';
import 'absen_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AbsenPage extends StatefulWidget {
  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  String? selectedCondition = 'Senang';
  TextEditingController descriptionController = TextEditingController();

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
            Text(
              'Lokasi:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 200, // Sesuaikan dengan kebutuhan
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      -6.2088, 106.8456), // Ganti dengan koordinat yang sesuai
                  zoom: 15, // Tingkat zoom awal
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('absen_location'),
                    position: LatLng(
                      double.tryParse(
                              absenState.koordinat?.split(',')[1] ?? '0') ??
                          0,
                      double.tryParse(
                              absenState.koordinat?.split(',')[0] ?? '0') ??
                          0,
                    ),
                    infoWindow: InfoWindow(title: 'Lokasi Absen'),
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  // Jika Anda memerlukan pengendalian peta, Anda dapat melakukannya di sini
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengambil gambar dari kamera
                _getImageFromCamera();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Ambil Gambar',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
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
              items: <String>['Senang', 'Lelah', 'Buruk']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan data absen ke server
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
      // Gambar berhasil diambil, Anda dapat melakukan sesuatu dengan gambar tersebut.
      // Misalnya, menyimpannya atau menampilkannya di layar.
    }
  }

  void _saveAbsenData() {
    // Implementasi logika untuk menyimpan data absen ke server
    final String description = descriptionController.text;
    final String condition = selectedCondition ?? '';

    // Kirim data absen ke server sesuai dengan kebutuhan
  }
}
