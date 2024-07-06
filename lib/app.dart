import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/auth/splash_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/profile_app_bar.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: buildLightThemeData(),
    );
  }

  ThemeData buildLightThemeData() {
    return ThemeData(

      textTheme: const TextTheme(
        titleLarge:  TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleSmall:  TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          letterSpacing: 0.4
        ),

      ),

      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: AppColors.white,
        hintStyle: TextStyle(
          color: Colors.grey.shade400
        )
      ),


      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: AppColors.white,
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12)
        ),
      ),

      textButtonTheme: TextButtonThemeData(
       style: TextButton.styleFrom(
         foregroundColor: Colors.grey,
         textStyle: const TextStyle(
           fontWeight: FontWeight.w600
         ),
       )
      ),

    );

  }
}
