import 'package:discourse/constants/appColor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

/// Custom Bottom Navigation Bar
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<String> _names = ['Digest', 'Review', 'Home', 'Forum', 'Market'];

  final List<IconData> _icons = [
    Icons.list,
    Icons.edit_square,
    Icons.home_rounded,
    Icons.people,
    Icons.shopping_bag
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, child) {
      return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: appState.currentPageIdxBottomNav,
          selectedFontSize: appState.showInBottomNav() ? 16 : 14,
          selectedItemColor: appState.showInBottomNav() ? AppColor().darkPurple : AppColor().inactiveBottomNavBar,
          unselectedItemColor: AppColor().inactiveBottomNavBar,
          unselectedFontSize: 14,
          onTap: (idx) {
            appState.navigateFromBottomNav(idx);
          },
          iconSize: 28,
          elevation: 48,
          backgroundColor: AppColor().primary,
          items: List.generate(5, (idx) {
            return BottomNavigationBarItem(
                icon: Icon(_icons[idx]), label: _names[idx]);
          }));
    });
  }
}
