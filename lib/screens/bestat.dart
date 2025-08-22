import 'dart:math';

import 'package:flutter/material.dart';
import 'package:love_choice/modules/appbars.dart';
import 'package:love_choice/modules/carddisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/soon.dart';

final String tablee = "bestat_choices";

class bestat extends StatefulWidget {
  const bestat({super.key});

  @override
  State<bestat> createState() => _bestatState();
}

class _bestatState extends State<bestat> {
  bool isDare = true;
  bool switch_both = false;
  bool pin_image = true;
  int rnum = Random().nextInt(10) + 1;
  int rnum2 = Random().nextInt(10) + 1;

  Future<void> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      isDare = pref.getBool('isDare') ?? true;
      switch_both = pref.getBool('switch_both') ?? false;
      pin_image = pref.getBool('pin_image') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!pin_image) {
      setState(() {
        rnum = Random().nextInt(10) + 1;
        rnum2 = Random().nextInt(10) + 1;
      });
    }
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/main");
        return Future.value(false);
      },
      child: Scaffold(
        appBar: TurkAppBar(tablee: tablee),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset("images/main2.jpg", fit: BoxFit.cover),
              ),
              isDare
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardsFactory(
                          tablee: tablee,
                          type: CardType.choice,
                          switchBoth: switch_both,
                          imageNumber: rnum,
                          style: CardStyle.towCard,
                        ),
                        CardsFactory(
                          tablee: tablee,
                          imageNumber: rnum2,
                          type: CardType.dare,
                          switchBoth: switch_both,
                          style: CardStyle.towCard,
                        ),
                      ],
                    )
                  : Center(
                      child: CardsFactory(
                        tablee: tablee,
                        imageNumber: rnum2,
                        type: CardType.choice,
                        switchBoth: switch_both,
                        style: CardStyle.towCard,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
