import 'package:flutter/cupertino.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final int selectedIndex;
  final void Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      backgroundColor: CupertinoColors.white,
      items: <BottomNavigationBarItem>[
        buildNavBarItem(
          icon: CupertinoIcons.home,
          label: 'Home',
          index: 0,
        ),
        buildNavBarItem(
          icon: CupertinoIcons.person,
          label: 'Profile',
          index: 1,
        ),
      ],
      onTap: onItemTapped,
      currentIndex: selectedIndex,
    );
  }

  BottomNavigationBarItem buildNavBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: selectedIndex == index ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
      ),
      label: label,
    );
  }
}
