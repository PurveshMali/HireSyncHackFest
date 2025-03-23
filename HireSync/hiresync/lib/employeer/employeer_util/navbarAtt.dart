import 'package:flutter/material.dart';

class NavbarAtt extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavbarAtt({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: Color(0xff0c0c0c),
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNavItem(Icons.add, "AddJob", 0),
              buildNavItem(Icons.history_outlined, "History", 1),
              buildNavItem(Icons.feedback_outlined, "Feedback", 2),
              buildNavItem(Icons.person, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a navigation item with an icon and label
  Widget buildNavItem(IconData icon, String label, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => onItemSelected(index),
        splashColor: Colors.orange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selectedIndex == index ? Colors.orange : Colors.white,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Font1',
                color: selectedIndex == index ? Colors.orange : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}