import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_bottom_nav.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _calculateIndex(GoRouterState.of(context).uri.path),
        onTap: (index) => _onTap(context, index),
      ),
    );
  }

  int _calculateIndex(String location) {
    if (location.startsWith('/cocktails')) return 1;
    if (location.startsWith('/map')) return 2;
    if (location.startsWith('/games')) return 3;
    if (location.startsWith('/settings') || location.startsWith('/contact')) {
      return 4;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/cocktails');
      case 2:
        context.go('/map');
      case 3:
        context.go('/games');
      case 4:
        context.go('/settings');
    }
  }
}
