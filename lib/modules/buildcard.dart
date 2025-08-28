import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redacted/redacted.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/toastdata.dart';

class Buildcard extends StatefulWidget {
  final String text;
  final String discribe;
  final String route;
  final bool? single;

  const Buildcard(
    this.text,
    this.discribe,
    this.route,
    this.single, {
    super.key,
  });

  @override
  State<Buildcard> createState() => _BuildcardState();
}

class _BuildcardState extends State<Buildcard> {
  bool warning18 = true;
  bool metgawzen_password = false;

  Future<void> loadwarning() async {
    final pref = await SharedPreferences.getInstance();
    warning18 = pref.getBool("warning18") ?? true;
    metgawzen_password = pref.getBool("metgawzen_password") ?? false;
  }

  @override
  void initState() {
    super.initState();
    loadwarning();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, "/${widget.route}");
          if (widget.route == "ahl") {
            turkToast(
              ahl_enter_tablee[Random().nextInt(ahl_enter_tablee.length)],
            );
          } else if (widget.route == "metgawzen") {
            warning18
                ? showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "تنويه هام",
                        style: TextStyle(fontFamily: "TurkFont", fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        "ملحوظة\nالفئة دي للمتجوزين بس وغير مسؤوليين عن اي طفل يدخل هنا {محتوى +18} وفي أي حالة ارجاع هذا التحذير الرجاء حذف الباسورد من الاعدادات، استمتعوا.",
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final pref = await SharedPreferences.getInstance();
                            await pref.setBool('warning18', false);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            "عدم العرض",
                            style: TextStyle(
                              fontFamily: "TurkFont",
                              fontSize: 15,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              "/metgawzen_password",
                            );
                          },
                          child: Text(
                            "باسورد",
                            style: TextStyle(
                              fontFamily: "TurkFont",
                              fontSize: 15,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
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
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  )
                : metgawzen_password
                ? Navigator.pushReplacementNamed(context, "/metgawzen_password")
                : null;
            turkToast(
              metgawzen_enter_tablee[Random().nextInt(
                metgawzen_enter_tablee.length,
              )],
            );
          } else if (widget.route == "ma5toben") {
            turkToast(
              ma5toben_enter_tablee[Random().nextInt(
                ma5toben_enter_tablee.length,
              )],
            );
          } else if (widget.route == "shella") {
            turkToast(
              shella_enter_tablee[Random().nextInt(shella_enter_tablee.length)],
            );
          } else if (widget.route == "t3arof") {
            turkToast(
              t3arof_enter_tablee[Random().nextInt(t3arof_enter_tablee.length)],
            );
          } else if (widget.route == "couples") {
            turkToast(
              couples_enter_tablee[Random().nextInt(
                couples_enter_tablee.length,
              )],
            );
          } else if (widget.route == "bestat") {
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
                child: Image.asset(
                  "images/${widget.route}.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              // height: 150,
              height: MediaQuery.of(context).size.height / 4 - 62.5,
              width: widget.single ?? false
                  ? MediaQuery.of(context).size.width - 20
                  : MediaQuery.of(context).size.width / 2 - 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      ),
                    ),
                  ),
                  Text(
                    widget.discribe,
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
  }

  void turkToast(String text) {
    if (Platform.isAndroid || Platform.isIOS) {
      Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
        fontAsset: "fonts/arabic_font.otf",
      );
    }
  }
}
