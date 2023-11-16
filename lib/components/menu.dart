import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../dashboard_page.dart';
import '../histori_page.dart';
import '../dataAbsen_page.dart';
import '../notif_page.dart';
import '../akun_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    HistoriPage(),
    DataAbsenPage(),
    NotifPage(),
    AkunPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: _selectedIndex == 0 ? Colors.black : Colors.white,),
          Icon(Icons.history, size: 30, color: _selectedIndex == 1 ? Colors.black : Colors.white,),
          Icon(Icons.fingerprint, size: 30, color: _selectedIndex == 2 ? Colors.black : Colors.white,),
          Icon(Icons.notifications, size: 30, color: _selectedIndex == 3 ? Colors.black : Colors.white,),
          Icon(Icons.account_circle, size: 30, color: _selectedIndex == 4 ? Colors.black : Colors.white,),
        ],
        color: Colors.blue,
        buttonBackgroundColor: Colors.yellow,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
