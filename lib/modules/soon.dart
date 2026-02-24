import 'package:flutter/material.dart';
import 'package:love_choice/modules/appBarRouter.dart';
import 'appbars.dart';
import 'package:lottie/lottie.dart';

class soonWidget extends StatelessWidget {
  const soonWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/main");
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarRouter(),
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
