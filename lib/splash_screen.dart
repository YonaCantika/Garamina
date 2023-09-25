import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    });
  }

  Widget _buildIconWithText(
      IconData iconData, Color backgroundColor, String text) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 30,
          ),
        ),
        SizedBox(height: 5), // Spasi vertikal antara ikon dan teks
        Text(
          text,
          style: TextStyle(
            fontSize: 12, // Ukuran teks
            color: Colors.black, // Warna teks
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            Image.asset(
              'assets/img/loader.gif',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 100), // Spasi vertikal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildIconWithText(Icons.security, Colors.blue, 'Keamanan'),
                _buildIconWithText(Icons.location_on, Colors.green, 'Lokasi'),
                _buildIconWithText(Icons.access_time, Colors.orange, 'Waktu'),
                _buildIconWithText(Icons.devices, Colors.purple, 'Perangkat'),
              ],
            ),
            SizedBox(height: 20), // Spasi vertikal
            // Text(
            //   'Garamina Mobile',
            //   style: TextStyle(
            //     fontSize: 24, // Ukuran teks
            //     color: Colors.blue, // Warna teks
            //     fontWeight: FontWeight.bold, // Ketebalan teks
            //   ),
            // ),
            SizedBox(height: 20), // Spasi vertikal
            // Tambahkan gambar di paling bawah
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/img/bumn.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
