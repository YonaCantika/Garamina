import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;

  CustomCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.blue,
      child: SizedBox(
        height: 90,
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.white),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
