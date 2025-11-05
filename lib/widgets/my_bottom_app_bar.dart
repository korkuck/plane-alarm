import 'package:flutter/material.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Find New Flight',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: 'Shate Flight Info',
        ),
      ],
    );
  }
}
