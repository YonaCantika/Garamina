import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Widget atau kelas lain yang menggunakan WebView
class BrowserPage extends StatelessWidget {
  final String url =
      'https://www.website.com'; // Ganti dengan URL yang diinginkan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survei Page'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode
            .unrestricted, // Aktifkan mode JavaScript jika diperlukan
      ),
    );
  }
}
