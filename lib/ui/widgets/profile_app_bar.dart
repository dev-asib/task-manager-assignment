import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_app/ui/screens/update_profile_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';

AppBar profileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () => _onTapProfileButton(context, fromUpdateProfile),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.memory(
                  base64Decode(AuthController.userData?.photo ?? ''))),
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () => _onTapProfileButton(context, fromUpdateProfile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(color: AppColors.white, fontSize: 16),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(color: AppColors.white, fontSize: 13),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          await AuthController.clearAllData();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false);
        },
        icon: const Icon(Icons.logout, color: Colors.white),
      ),
    ],
  );
}

void _onTapProfileButton(context, fromUpdateProfile) {
  {
    if (fromUpdateProfile) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdateProfileScreen(),
      ),
    );
  }
}
