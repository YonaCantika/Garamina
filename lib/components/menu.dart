import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  BottomMenu({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        const BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/img/logo.png',
            width: 23,
            height: 23,
          ),
          label: 'Absen',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.notifications),
          label: 'Notifikasi',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle),
          label: 'Akun',
        ),
      ],
      selectedItemColor: Colors.black, // Warna item yang dipilih
      unselectedItemColor: Colors.black, // Warna item yang tidak dipilih
    );
  }
}
