import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redacted/redacted.dart';

class Buildcard extends StatelessWidget {
  final String text;
  final String discribe;
  final String route;

  const Buildcard(this.text, this.discribe, this.route, {super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQueryData().size;
    List<String> ahl_enter_tablee = [
      "يجمعكم على خير 🌙.",
      "ربنا يديمكم سوا 🌙.",
      "سلملي عليهم 🌙.",
      "منورين 🌙.",
    ];
    List<String> metgawzen_enter_tablee = [
      "بعشقك 💕.",
      "كل اللي ليا 💕.",
      "ادماني 💕.",
      "ضي عيني 💕.",
    ];
    List<String> ma5toben_enter_tablee = ["انت مين بكرا؟ 💍."];
    List<String> shella_enter_tablee = ["خروجة من غيري!؟ 😂."];
    List<String> t3arof_enter_tablee = ["يلا بينا 😎."];
    List<String> couples_enter_tablee = ["بحبك ❤️."];
    List<String> bestat_enter_tablee = ["مفتاح 💙."];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, "/$route");
          if (route == "ahl") {
            turkToast(
              ahl_enter_tablee[Random().nextInt(ahl_enter_tablee.length)],
            );
          } else if (route == "metgawzen") {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "تنويه هام",
                  style: TextStyle(fontFamily: "TurkFont", fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "ملحوظة",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "فهمت",
                      style: TextStyle(
                        fontFamily: "TurkFont",
                        fontSize: 15,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                ],
              ),
            );
            turkToast(
              metgawzen_enter_tablee[Random().nextInt(
                metgawzen_enter_tablee.length,
              )],
            );
          } else if (route == "ma5toben") {
            turkToast(
              ma5toben_enter_tablee[Random().nextInt(
                ma5toben_enter_tablee.length,
              )],
            );
          } else if (route == "shella") {
            turkToast(
              shella_enter_tablee[Random().nextInt(shella_enter_tablee.length)],
            );
          } else if (route == "t3arof") {
            turkToast(
              t3arof_enter_tablee[Random().nextInt(t3arof_enter_tablee.length)],
            );
          } else if (route == "couples") {
            turkToast(
              couples_enter_tablee[Random().nextInt(
                couples_enter_tablee.length,
              )],
            );
          } else if (route == "bestat") {
            turkToast(
              bestat_enter_tablee[Random().nextInt(bestat_enter_tablee.length)],
            );
          } else {
            turkToast("طب مثا من عندي");
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("images/$route.jpg", fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      ),
                    ),
                  ),
                  Text(
                    discribe,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return Expanded(
    //   child: InkWell(
    //     onTap: () {
    //       Navigator.pushReplacementNamed(context, "/$route");
    //     },
    //     child: Card(
    //       color: Colors.transparent,
    //       child: SizedBox(
    //         width: double.infinity,
    //         child: Stack(
    //           children: [
    //             Positioned.fill(
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(20),
    //                 child: Image.asset("images/$route.jpg", fit: BoxFit.cover),
    //               ),
    //             ),
    //             Container(
    //               margin: EdgeInsets.all(size.width * 0.8),
    //               // padding: EdgeInsets.all(5),
    //               child: Center(
    //                 child: SizedBox(
    //                   width: double.infinity,
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     spacing: 15,
    //                     children: [
    //                       Text(
    //                         text,
    //                         textAlign: TextAlign.center,
    //                         textDirection: TextDirection.rtl,
    //                         style: TextStyle(
    //                           shadows: [
    //                             Shadow(blurRadius: 10, color: Colors.black),
    //                           ],
    //                         ),
    //                       ),
    //                       Text(
    //                         discribe,
    //                         softWrap: true,
    //                         style: TextStyle(
    //                           fontSize: 14,
    //                           shadows: [
    //                             Shadow(blurRadius: 10, color: Colors.black),
    //                           ],
    //                         ),
    //                         textAlign: TextAlign.center,
    //                         textDirection: TextDirection.rtl,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  void turkToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
