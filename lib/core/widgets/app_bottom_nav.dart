import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wine_bar_rounded),
          label: 'Cocktails',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_rounded),
          label: 'Bars',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.casino_rounded),
          label: 'Jeux',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_rounded),
          label: 'Plus',
        ),
      ],
    );
  }
}
