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
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    });
  }

  Widget _buildIconWithText(
      path, Color backgroundColor, String text) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // child: Icon(
          //   iconData,
          //   color: Colors.white,
          //   size: 30,
          // ),
          child: Image.asset(
            path,
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(height: 5), // Spasi vertikal antara ikon dan teks
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight:FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 150),
            Image.asset(
              'assets/img/loader.gif',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 100), // Spasi vertikal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildIconWithText('assets/img/screen/emergency.png', Colors.blue, 'Emergency'),
                _buildIconWithText('assets/img/screen/gps.png', Colors.green, 'Detection'),
                _buildIconWithText('assets/img/screen/location.png', Colors.orange, 'Realtime'),
                _buildIconWithText('assets/img/screen/phone.png', Colors.purple, 'Secure'),
              ],
            ),
            const SizedBox(height: 20), // Spasi vertikal
            const SizedBox(height: 20), // Spasi vertikal
            // Tambahkan gambar di paling bawah
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                // child: const Text("from"),
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
