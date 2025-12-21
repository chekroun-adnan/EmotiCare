import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
               Icon(Icons.spa, color: AppTheme.primary, size: 32),
               const SizedBox(width: 10),
               Text(
                 'EmotiCare',
                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
               ),
            ],
          ),
          const SizedBox(height: 50),
          
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isSelected: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _SidebarItem(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            isSelected: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),
           _SidebarItem(
             icon: Icons.check_circle_outline,
             label: 'Habits',
             isSelected: selectedIndex == 2,
             onTap: () => onItemSelected(2),
           ),
           _SidebarItem(
             icon: Icons.face_retouching_natural,
             label: 'Digital Twin',
             isSelected: selectedIndex == 3,
             onTap: () => onItemSelected(3),
           ),
            _SidebarItem(
            icon: Icons.mood,
            label: 'Mood Tracker',
            isSelected: selectedIndex == 4,
            onTap: () => onItemSelected(4),
          ),
          _SidebarItem(
            icon: Icons.book_outlined,
            label: 'Journal',
            isSelected: selectedIndex == 5,
            onTap: () => onItemSelected(5),
          ),
          _SidebarItem(
            icon: Icons.flag_outlined,
            label: 'Goals',
            isSelected: selectedIndex == 6,
            onTap: () => onItemSelected(6),
          ),
           _SidebarItem(
            icon: Icons.people_outline,
            label: 'Community',
            isSelected: selectedIndex == 7,
            onTap: () => onItemSelected(7),
          ),
          
          const Spacer(),
           _SidebarItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isSelected: selectedIndex == 8,
            onTap: () => onItemSelected(8),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
