import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager_app/ui/utility/assets_paths.dart';

class CenteredEmptyLottie extends StatelessWidget {
  const CenteredEmptyLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AssetsPaths.emptyLottie),
          const Text(
            "Empty",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
