import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_state.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StatusCuti extends StatefulWidget {
  @override
  _StatusCutiState createState() => _StatusCutiState();
}

class _StatusCutiState extends State<StatusCuti> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const Text(
                    'Status Pengajuan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'assets/img/dashboard/develop.png',
                    width: 300,
                    height: 300,
                  ),
                  const Text(
                    'To be Develop...',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
