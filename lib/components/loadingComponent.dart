import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/img/bg.png'), // Background image
          fit: BoxFit.cover, // Sesuaikan ukuran gambar dengan konten
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.2), // Warna efek putih dengan opasitas 0.7 (untuk penyesuaian)
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
    );
  }
}
