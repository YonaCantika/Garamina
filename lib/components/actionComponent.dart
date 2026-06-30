import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_state.dart';

Widget buildUserGuide(BuildContext context) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Petunjuk Pengguna',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    ListView(
                      shrinkWrap: true,
                      children: const [
                        Text(
                          '1. Bagaimana cara melakukan absen normal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('penjelasan: ...'),
                        SizedBox(height: 20),
                        Text(
                          '2. Bagaimana cara melihat beberapa informasi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('penjelasan: ...'),
                        SizedBox(height: 20),
                        Text(
                          '3. Bagaimana cara mengajukan cuti, izin dan dinas',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('penjelasan: ...'),
                        SizedBox(height: 20),
                        Text(
                          '4. Bagaimana cara melakukan absen darurat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('penjelasan: ...'),
                        SizedBox(height: 20),
                        Text(
                          '5. Support tim',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('penjelasan: ...'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
    child: const SizedBox(
      height: 50,
      width: 50,
      child: Icon(Icons.menu_book, size: 30, color: Colors.black),
    ),
  );
}

Widget buildInformationCenter(BuildContext context) {
  final authState = Provider.of<AuthState>(context);
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Pusat Informasi',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    authState.info != null
                        ? Image.network(
                            authState.info.toString(),
                            width: 450,
                            height: 450,
                          )
                        : Image.asset(
                            'assets/img/pusatInformasi/regulasi.png',
                            width: 450,
                            height: 450,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
    child: const SizedBox(
      height: 50,
      width: 50,
      child: Icon(Icons.info, size: 30, color: Colors.black),
    ),
  );
}
