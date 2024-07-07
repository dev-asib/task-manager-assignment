import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';

class CenterdProgressIndicator extends StatelessWidget {
  const CenterdProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.themeColor,
      ),
    );
  }
}
