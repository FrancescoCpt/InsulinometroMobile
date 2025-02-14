import 'package:flutter/material.dart';
import 'package:app/ui/pages/home_page.dart';
import 'package:app/ui/pages/secondary_page.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  CustomBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Dispositivo',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsulinometerHome()),
          );
        }
      },
    );
  }
}
