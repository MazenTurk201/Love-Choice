// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPageBuilder extends StatelessWidget {
  final String lottie;
  final String title;
  final String discribtion;
  const OnboardingPageBuilder({
    super.key,
    required this.lottie,
    required this.title,
    required this.discribtion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(child: Text(title)),
    );
  }
}
