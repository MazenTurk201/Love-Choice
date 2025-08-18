// ignore_for_file: sized_box_for_whitespace

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:love_choice/modules/appbars.dart';
import 'package:redacted/redacted.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db_helper.dart';
import '../modules/soon.dart';

final String tablee = "ma5toben_choices";

class ma5toben extends StatefulWidget {
  const ma5toben({super.key});

  @override
  State<ma5toben> createState() => _ma5tobenState();
}

class _ma5tobenState extends State<ma5toben> {
  bool pin_image = true;
  int rnum = Random().nextInt(10) + 1;
  int rnum2 = Random().nextInt(10) + 1;
  // ignore: unused_field
  late bool _isloading;

  @override
  void initState() {
    _isloading = true;
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isloading = false;
      });
    });
    getRandUsers();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      pin_image = pref.getBool('pin_image') ?? true;
    });
  }

  List<Map<String, dynamic>> randquizs = [];
  int index = 0;

  void getRandUsers() async {
    final data = await DBHelper.getRandUsers(tablee);
    setState(() {
      randquizs = data;
    });
  }

  Future<Map<String, dynamic>> loadRandomUser() async {
    final user = await DBHelper.getRandomUser(tablee);
    if (user != null) {
      return {'choice': user['choice'], 'dare': user['dare']};
    }
    return {}; // Return an empty map if user is null
  }

  @override
  Widget build(BuildContext context) {
    if (!pin_image) {
      rnum = Random().nextInt(10) + 1;
      rnum2 = Random().nextInt(10) + 1;
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
              Center(child: cardDisplay(rnum, "choice", false)),
            ],
          ),
        ),
      ),
    );
  }

  Container cardDisplay(int random_number, String type, bool switch_both) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "images/quiz$random_number.jpg",
                fit: BoxFit.cover,
              ).redacted(context: context, redact: _isloading),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: _isloading
                    ? Container(
                        width: 100,
                        height: 50,
                      ).redacted(context: context, redact: _isloading)
                    : Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "سؤال",
                              style: TextStyle(
                                fontSize: 30,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ).redacted(context: context, redact: _isloading),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            tooltip: "ليه السؤال ده؟",
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    "ليه السؤال ده؟",
                                    style: TextStyle(
                                      fontFamily: "TurkFont",
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    randquizs.isNotEmpty
                                        ? randquizs[index]["dare"]
                                        : 'لا يوجد بيانات بعد',
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
                            },
                            icon: Icon(
                              Icons.info_outline,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
              Center(
                child: _isloading
                    ? Text(
                        'fetching data',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ).redacted(context: context, redact: _isloading)
                    : Text(
                        randquizs.isNotEmpty
                            ? randquizs[index][type]
                            : 'لا يوجد بيانات بعد',
                        style: TextStyle(
                          fontSize: 24,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // spacing: 50,
                  children: [
                    _isloading
                        ? Container(
                            width: 50,
                            height: 50,
                          ).redacted(context: context, redact: _isloading)
                        : IconButton(
                            onPressed: () {
                              SharePlus.instance.share(
                                ShareParams(
                                  text:
                                      '''السؤال: ${randquizs[index][type]}\n\nليه السؤال ده؟: ${randquizs[index]["dare"]}''',
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.share,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                    _isloading
                        ? Container(
                            width: 50,
                            height: 50,
                          ).redacted(context: context, redact: _isloading)
                        : IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text:
                                      '''السؤال: ${randquizs[index][type]}\n\nليه السؤال ده؟: ${randquizs[index]["dare"]}''',
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                    _isloading
                        ? Container(
                            width: 50,
                            height: 50,
                          ).redacted(context: context, redact: _isloading)
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                if (index == randquizs.length - 1) {
                                  index = 0;
                                } else {
                                  index++;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.swipe_right,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
