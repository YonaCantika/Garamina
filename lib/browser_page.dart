import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:garamina/services/api_services.dart';

class BrowserPage extends StatefulWidget {
  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final String url = ApiServices.loginUrl;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survei Page'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
