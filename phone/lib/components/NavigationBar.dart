import 'package:flutter/material.dart';
import 'package:phone/styles/colors.dart';

enum NavBarItem { Profile, Home, Charts }

class CustomBottomNavigationBar extends StatelessWidget {
  final NavBarItem selectedItem;
  final Function(NavBarItem) onItemSelected;

  const CustomBottomNavigationBar({
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: blueColor.withOpacity(0.8),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: blueColor.withOpacity(0.3),
            offset: const Offset(0, 20),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavBarItem(NavBarItem.Profile, Icons.person_rounded),
          buildNavBarItem(NavBarItem.Home, Icons.home_rounded),
          buildNavBarItem(NavBarItem.Charts, Icons.pie_chart_sharp),
        ],
      ),
    );
  }

  Widget buildNavBarItem(NavBarItem item, IconData icon) {
    bool isSelected = selectedItem == item;
    return GestureDetector(
      onTap: () => onItemSelected(item),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? blueColor : Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
