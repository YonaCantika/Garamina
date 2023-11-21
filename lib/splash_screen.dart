import 'package:flutter/material.dart';
import 'package:garamina/dashboard_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      // _getPreference();
    });
  }

  Future<void> _getPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(
    prefs.getString('costCenter') != null &&
    prefs.getString('idPeg') != null &&
    prefs.getString('namaUser') != null &&
    prefs.getString('nik') != null &&
    prefs.getString('costid') != null &&
    prefs.getString('idLokasi') != null &&
    prefs.getString('lokasi') != null &&
    prefs.getString('status') != null &&
    prefs.getString('foto') != null &&
    prefs.getString('foto_pengumuman') != null
    ){
      final authState = Provider.of<AuthState>(context, listen: false);
      authState.setAuthData(
        costCenter: prefs.getString('costCenter'),
        idPeg: prefs.getString('idPeg'),
        namaUser: prefs.getString('namaUser'),
        nik: prefs.getString('nik'),

        costid: prefs.getString('costid'),
        idLokasi: prefs.getString('idLokasi'),
        lokasi: prefs.getString('lokasi'),
        status: prefs.getString('status'),
        foto: prefs.getString('foto'),
        info: prefs.getString('foto_pengumuman'),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardPage(),
        ),
      );
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
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
          child: Image.asset(
            path,
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(height: 5),
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
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildIconWithText('assets/img/screen/emergency.png', Colors.blue, 'Emergency'),
                _buildIconWithText('assets/img/screen/gps.png', Colors.green, 'Detection'),
                _buildIconWithText('assets/img/screen/location.png', Colors.orange, 'Realtime'),
                _buildIconWithText('assets/img/screen/phone.png', Colors.purple, 'Secure'),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            // gambar bumn
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
