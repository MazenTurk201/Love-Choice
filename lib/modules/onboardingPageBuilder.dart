// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingPageBuilder extends StatelessWidget {
  final String lottie;
  final String title;
  final String discribtion;
  final String link;
  final List<Color> colors;
  const OnboardingPageBuilder({
    super.key,
    required this.lottie,
    required this.title,
    required this.discribtion,
    required this.link,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (lottie.isNotEmpty)
            Lottie.asset(lottie, width: 300, height: 300, fit: BoxFit.fill),
          Text(title, style: TextStyle()),
          Text(
            discribtion,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(),
          if (link.isNotEmpty)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                _launchUrl(link);
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colors[0], colors[1]]),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 150,
                  child: Text(
                    "من هنا",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: "TurkFont",
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch URL: $url');
  }
}
