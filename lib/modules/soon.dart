import 'package:flutter/material.dart';
import 'appbars.dart';
import 'package:lottie/lottie.dart';

class soonWidget extends StatelessWidget {
  final String tablee;
  const soonWidget({super.key, required this.tablee});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/main");
        return Future.value(false);
      },
      child: Scaffold(
        appBar: TurkAppBar(tablee: tablee),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/animation/Error 404.json",
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                Text(
                  "Comming Soon...",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: "TurkFontE",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
