// ignore_for_file: file_names, sized_box_for_whitespace

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:love_choice/data/db_helper.dart';
import 'package:redacted/redacted.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardsFactory extends StatefulWidget {
  final String tablee;
  final CardType type; // "quiz" أو "dare"
  final bool? switchBoth;
  final int imageNumber;
  final CardStyle style;

  const CardsFactory({
    super.key,
    required this.tablee,
    required this.type,
    this.switchBoth,
    required this.imageNumber,
    this.style = CardStyle.towCardRandom,
  });

  @override
  State<CardsFactory> createState() => _CardsFactoryState();
}

enum CardStyle { towCard, oneCard, towCardRandom }

enum CardType { choice, dare }

class _CardsFactoryState extends State<CardsFactory> {
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

    if (!mounted) return;

    setState(() {
      randQuizs = data;
      randDares = (data.reversed).toList();
      textQuiz = randQuizs.isNotEmpty ? randQuizs[index]['choice'] ?? '' : '';
      textDare = randDares.isNotEmpty ? randDares[dareIndex]['dare'] ?? '' : '';
      _isloading = false;
    });
  }

  void _onNext() {
    setState(() {
      if (widget.switchBoth ?? false) {
        index = (index + 1) % randQuizs.length;
        dareIndex = (dareIndex + 1) % randDares.length;
      } else {
        if (widget.type == CardType.dare) {
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
    switch (widget.style) {
      case CardStyle.towCardRandom:
        return Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          height: 225,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    pinImage
                        ? "images/quiz${widget.imageNumber}.jpg"
                        : "images/quiz${Random().nextInt(10) + 1}.jpg",
                    fit: BoxFit.cover,
                  ).redacted(context: context, redact: _isloading),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      widget.type == CardType.dare ? "تحدي" : "سؤال",
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
                  _isloading
                      ? Text(
                          'fetching data',
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ).redacted(context: context, redact: _isloading)
                      : Text(
                          // choiceText ?? '',
                          widget.type == CardType.dare
                              ? randDares.isNotEmpty
                                    ? randDares[dareIndex]["dare"]
                                    : 'لا يوجد بيانات بعد'
                              // Choice
                              : randQuizs.isNotEmpty
                              ? randQuizs[index]["choice"]
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                      text: widget.type == CardType.dare
                                          ? textDare.toString()
                                          : textQuiz.toString(),
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
                                      text: widget.type == CardType.dare
                                          ? textDare.toString()
                                          : textQuiz.toString(),
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
                                    if (widget.switchBoth ?? false) {
                                      if (index == randQuizs.length - 1) {
                                        index = -1;
                                      }
                                      if (dareIndex == randDares.length - 1) {
                                        dareIndex = -1;
                                      }
                                      index++;
                                      dareIndex++;
                                      textQuiz =
                                          randQuizs[index]['choice'] ?? '';
                                      textDare = randQuizs[index]['dare'] ?? '';
                                    } else {
                                      if (widget.type == CardType.dare) {
                                        if (dareIndex == randDares.length - 1) {
                                          dareIndex = 0;
                                          textDare = randQuizs[0]['dare'] ?? '';
                                        } else {
                                          dareIndex++;
                                          textDare =
                                              randQuizs[dareIndex]['dare'] ??
                                              '';
                                        }
                                      } else {
                                        if (index == randQuizs.length - 1) {
                                          index = 0;
                                          textQuiz =
                                              randQuizs[0]['choice'] ?? '';
                                        } else {
                                          index++;
                                          textQuiz =
                                              randQuizs[index]['choice'] ?? '';
                                        }
                                      }
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

      case CardStyle.towCard:
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "images/quiz${widget.imageNumber}.jpg",
                    fit: BoxFit.cover,
                  ).redacted(context: context, redact: _isloading),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      _isloading
                          ? "dataa"
                          : widget.type == CardType.dare
                          ? "تحدي"
                          : "سؤال",
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
                  _isloading
                      ? const Text(
                          'gary altahmel',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                          textAlign: TextAlign.center,
                        ).redacted(context: context, redact: _isloading)
                      : Text(
                          widget.type == CardType.dare
                              ? (randDares.isNotEmpty
                                    ? randDares[dareIndex]['dare']
                                    : 'لا يوجد بيانات بعد')
                              : (randQuizs.isNotEmpty
                                    ? randQuizs[index]['choice']
                                    : 'لا يوجد بيانات بعد'),
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _isloading
                            ? Container(
                                height: 40,
                                width: 40,
                              ).redacted(context: context, redact: _isloading)
                            : IconButton(
                                onPressed: _isloading
                                    ? null
                                    : () {
                                        Share.share(
                                          widget.type == CardType.dare
                                              ? textDare
                                              : textQuiz,
                                        );
                                      },
                                icon: const Icon(
                                  Icons.share,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                        _isloading
                            ? Container(
                                height: 40,
                                width: 40,
                              ).redacted(context: context, redact: _isloading)
                            : IconButton(
                                onPressed: _isloading
                                    ? null
                                    : () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: widget.type == CardType.dare
                                                ? textDare
                                                : textQuiz,
                                          ),
                                        );
                                      },
                                icon: const Icon(
                                  Icons.copy,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                        _isloading
                            ? Container(
                                height: 40,
                                width: 40,
                              ).redacted(context: context, redact: _isloading)
                            : IconButton(
                                onPressed: _onNext,
                                icon: const Icon(
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

      case CardStyle.oneCard:
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
                    pinImage
                        ? "images/quiz${widget.imageNumber}.jpg"
                        : "images/quiz${Random().nextInt(10) + 1}.jpg",
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
                                child:
                                    Text(
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
                                    ).redacted(
                                      context: context,
                                      redact: _isloading,
                                    ),
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
                                        randQuizs.isNotEmpty
                                            ? randQuizs[index]["dare"]
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
                            randQuizs.isNotEmpty
                                ? randQuizs[index]["choice"]
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
                                          '''*السؤال:* * ${randQuizs[index]["choice"]}\n\n*ليه السؤال ده؟:* * ${randQuizs[index]["dare"]}''',
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
                                          '''*السؤال:* * ${randQuizs[index]["choice"]}\n\n*ليه السؤال ده؟:* * ${randQuizs[index]["dare"]}''',
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
                                    if (index == randQuizs.length - 1) {
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
}
