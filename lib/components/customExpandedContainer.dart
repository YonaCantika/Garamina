import 'package:flutter/material.dart';

class CustomExpandedContainer extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final bool loading;
  final bool dataResponse;
  final Widget Function(BuildContext, int) itemBuilder; // Menambahkan itemBuilder

  CustomExpandedContainer({
    required this.title,
    required this.data,
    required this.loading,
    required this.dataResponse,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(
                child: Text('Loading...'),
              )
                  : !dataResponse
                  ? const Center(
                child: Text('Data tidak tersedia!'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return itemBuilder(context, index); // Menggunakan itemBuilder yang disediakan
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
