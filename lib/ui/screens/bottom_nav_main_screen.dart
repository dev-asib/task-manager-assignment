import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/cancalled_task_screen.dart';
import 'package:task_manager_app/ui/screens/completed_task_screen.dart';
import 'package:task_manager_app/ui/screens/inprogress_task_screen.dart';
import 'package:task_manager_app/ui/screens/new_task_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/profile_app_bar.dart';

class BottomNavMainScreen extends StatefulWidget {
  const BottomNavMainScreen({
    super.key,
  });

  @override
  State<BottomNavMainScreen> createState() => _BottomNavMainScreenState();
}

class _BottomNavMainScreenState extends State<BottomNavMainScreen> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    const NewTaskScreen(),
    const CompletedTaskScreen(),
    const InProgressTaskScreen(),
    const CancelledTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.themeColor,
        unselectedItemColor: AppColors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;
          if (mounted) {
            setState(() {});
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'New',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.downloading),
            label: 'InProgress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close_outlined),
            label: 'Cancelled',
          ),
        ],
      ),
    );
  }
}
