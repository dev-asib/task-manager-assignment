import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/app.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (_) => const TaskManagerApp(),
    ),
  );
}
