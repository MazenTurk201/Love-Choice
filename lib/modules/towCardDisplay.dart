// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:love_choice/data/db_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardDisplay extends StatefulWidget {
  final String tablee;
  final int randomNumber;
  final String type;
  final bool switchBoth;

  const CardDisplay({
    super.key,
    required this.randomNumber,
    required this.type,
    required this.switchBoth,
    required this.tablee,
  });

  @override
  State<CardDisplay> createState() => _CardDisplayState();
}

class _CardDisplayState extends State<CardDisplay> {
  bool isDare = true;
  bool pinImage = true;
  bool _isloading = true;

  List<Map<String, dynamic>> randQuizs = [];
  List<Map<String, dynamic>> randDares = [];
  int index = 0;
  int dareIndex = 0;
  String textQuiz = '';
  String textDare = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getRandUsers();
  }

  Future<void> _loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      isDare = pref.getBool('isDare') ?? true;
      pinImage = pref.getBool('pin_image') ?? true;
    });
  }

  void _getRandUsers() async {
    final data = await DBHelper.getRandUsers(widget.tablee);
    final data2 = await DBHelper.getRandUsers(widget.tablee);

    if (!mounted) return; // لو الـ widget اتشال قبل ما الداتا ترجع

    setState(() {
      randQuizs = data;
      randDares = data2;
      textQuiz = randQuizs.isNotEmpty ? randQuizs[index]['choice'] ?? '' : '';
      textDare = randDares.isNotEmpty ? randDares[dareIndex]['dare'] ?? '' : '';
      _isloading = false;
    });
  }

  void _onNext() {
    setState(() {
      if (widget.switchBoth) {
        index = (index + 1) % randQuizs.length;
        dareIndex = (dareIndex + 1) % randDares.length;
      } else {
        if (widget.type == "dare") {
          dareIndex = (dareIndex + 1) % randDares.length;
        } else {
          index = (index + 1) % randQuizs.length;
        }
      }
      textQuiz = randQuizs.isNotEmpty ? randQuizs[index]['choice'] ?? '' : '';
      textDare = randDares.isNotEmpty ? randDares[dareIndex]['dare'] ?? '' : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
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
                "images/quiz${widget.randomNumber}.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  widget.type == "dare" ? "تحدي" : "سؤال",
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
                ),
              ),
              _isloading
                  ? Text(
                      'fetching data',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    )
                  : Text(
                      widget.type == "dare"
                          ? (randDares.isNotEmpty
                                ? randDares[dareIndex][widget.type]
                                : 'لا يوجد بيانات بعد')
                          : (randQuizs.isNotEmpty
                                ? randQuizs[index][widget.type]
                                : 'لا يوجد بيانات بعد'),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _isloading
                        ? SizedBox(width: 50, height: 50)
                        : IconButton(
                            onPressed: () {
                              Share.share(
                                widget.type == "dare" ? textDare : textQuiz,
                              );
                            },
                            icon: Icon(
                              Icons.share,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                    _isloading
                        ? SizedBox(width: 50, height: 50)
                        : IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: widget.type == "dare"
                                      ? textDare
                                      : textQuiz,
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
                        ? SizedBox(width: 50, height: 50)
                        : IconButton(
                            onPressed: _onNext,
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
