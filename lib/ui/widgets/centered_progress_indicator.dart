import 'package:flutter/material.dart';

class CenterdProgressIndicator extends StatelessWidget {
  const CenterdProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
