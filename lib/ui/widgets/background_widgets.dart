import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/ui/utility/assets_paths.dart';

class BackgroundWidgets extends StatelessWidget {
  const BackgroundWidgets({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        SvgPicture.asset(
          AssetsPaths.backgroundSVG,
          height: double.maxFinite,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
        child
      ],
    );
  }
}
