// ignore_for_file: file_names, sized_box_for_whitespace

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/db_helper.dart';
import '../modules/skileton.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style/styles.dart';

class CardsFactory extends StatefulWidget {
  final String tablee;
  final CardStyle style;

  const CardsFactory({
    super.key,
    required this.tablee,
    this.style = CardStyle.towCardRandom,
  });

  @override
  State<CardsFactory> createState() => _CardsFactoryState();
}

enum CardStyle { towCard, oneCard, towCardRandom }

enum CardType { choice, dare }

enum TurkAnimType { fromRight, toLeft, pupup }

class _CardsFactoryState extends State<CardsFactory>
    with TickerProviderStateMixin {
  bool isDare = true;
  bool pinImage = true;
  bool switchBoth = true;
  bool spic_share = false;
  String spic_share_text = "";
  bool _isloading = true;
  double font_Size = 24;
  int rnum = Random().nextInt(20) + 1;
  int rnum2 = Random().nextInt(20) + 1;

  // List<Map<String, dynamic>> normalQuizs = [];
  List<Map<String, dynamic>> randQuizs = [];
  List<Map<String, dynamic>> randDares = [];
  int index = 0;
  int dareIndex = 0;

  late AnimationController _uptextController;
  late AnimationController _downtextController;
  double textDrag = 0.0;
  final double swipeThreshold = 0.3;
  TurkAnimType _animTypeDare = TurkAnimType.toLeft;
  TurkAnimType _animTypeChoice = TurkAnimType.toLeft;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getRandUsers();
    _uptextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _downtextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _uptextController.dispose();
    _downtextController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      isDare = pref.getBool('isDare') ?? true;
      switchBoth = pref.getBool('switch_both') ?? true;
      pinImage = pref.getBool('pin_image') ?? true;
      spic_share = pref.getBool('spic_share') ?? false;
      spic_share_text = pref.getString('spic_share_text') ?? "";
      font_Size = pref.getDouble('font_Size') ?? 24;
    });
  }

  void _getRandUsers() async {
    final data = await DBHelper.getRandUsers(widget.tablee);
    // final normalData = await DBHelper.getRandUsers(widget.tablee);

    if (!mounted) return;

    setState(() {
      randQuizs = data;
      // normalQuizs = normalData;
      randDares = (data.reversed).toList();
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!pinImage) {
      rnum = Random().nextInt(20) + 1;
      rnum2 = Random().nextInt(20) + 1;
    }
    switch (widget.style) {
      case CardStyle.towCardRandom:
        GestureDetector iconsRow = GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              spic_share
                  ? _launchUrl(
                      "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randDares[dareIndex]["dare"]}")}",
                    )
                  : SharePlus.instance.share(
                      ShareParams(
                        text:
                            "*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randDares[dareIndex]["dare"]}",
                      ),
                    );
            } else if (details.primaryVelocity! < 0) {
              setState(() {
                if (switchBoth) {
                  if (index == randQuizs.length - 1) {
                    index = -1;
                  }
                  if (dareIndex == randDares.length - 1) {
                    dareIndex = -1;
                  }
                  index++;
                  dareIndex++;
                }
              });
            }
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber,
              gradient: LinearGradient(
                colors: [TurkStyle().mainColor, Colors.indigo],
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 20, spreadRadius: 3),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    spic_share
                        ? _launchUrl(
                            "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randDares[dareIndex]["dare"]}")}",
                          )
                        : SharePlus.instance.share(
                            ShareParams(
                              text:
                                  "*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randDares[dareIndex]["dare"]}",
                            ),
                          );
                  },
                  icon: Icon(Icons.share, size: 35, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            "*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randDares[dareIndex]["dare"]}",
                      ),
                    );
                  },
                  icon: Icon(Icons.copy, size: 35, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (switchBoth) {
                        if (index == randQuizs.length - 1) {
                          index = -1;
                        }
                        if (dareIndex == randDares.length - 1) {
                          dareIndex = -1;
                        }
                        index++;
                        dareIndex++;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.swipe_left_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
        return _isloading
            ? isDare
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SkiletonSkin(),
                        SkiletonSkin(),
                        if (switchBoth)
                          SkiletonSkin(style: SkiletonStyle.iconsrow),
                      ],
                    )
                  : SkiletonSkin()
            : isDare
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  towCardRandowmMethod(context, CardType.choice, rnum, 0),
                  towCardRandowmMethod(context, CardType.dare, 0, rnum2),
                  if (switchBoth) iconsRow,
                ],
              )
            : Center(
                child: towCardRandowmMethod(context, CardType.choice, rnum, 0),
              );

      case CardStyle.towCard:
        GestureDetector iconsRow = GestureDetector(
          onTap: () {
            /* Don't do anything..*/
          },
          onHorizontalDragUpdate: (details) {
            final delta =
                details.primaryDelta! / MediaQuery.of(context).size.width;

            textDrag += delta;
            textDrag = textDrag.clamp(-1.0, 1.0);

            _uptextController.value = textDrag.abs();
            _downtextController.value = textDrag.abs();
            if (textDrag > 0 &&
                _animTypeDare != TurkAnimType.pupup &&
                _animTypeChoice != TurkAnimType.pupup) {
              setState(() {
                _animTypeDare = TurkAnimType.pupup;
                _animTypeChoice = TurkAnimType.pupup;
              });
            } else if (textDrag < 0 &&
                _animTypeDare != TurkAnimType.toLeft &&
                _animTypeChoice != TurkAnimType.toLeft) {
              setState(() {
                _animTypeDare = TurkAnimType.toLeft;
                _animTypeChoice = TurkAnimType.toLeft;
              });
            }
          },
          onHorizontalDragEnd: (_) async {
            if (textDrag > swipeThreshold) {
              setState(() {
                _animTypeDare = TurkAnimType.pupup;
                _animTypeChoice = TurkAnimType.pupup;
              });

              await _uptextController.animateTo(
                1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
              );
              await _uptextController.animateBack(
                0.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeIn,
              );
              await _downtextController.animateTo(
                1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
              );
              await _downtextController.animateBack(
                0.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeIn,
              );

              spic_share
                  ? _launchUrl(
                      "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randQuizs[dareIndex]["dare"]}")}",
                    )
                  : SharePlus.instance.share(
                      ShareParams(
                        text:
                            "*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randQuizs[dareIndex]["dare"]}",
                      ),
                    );
            } else if (textDrag < -swipeThreshold) {
              setState(() {
                _animTypeDare = TurkAnimType.toLeft;
                _animTypeChoice = TurkAnimType.toLeft;
              });

              await _uptextController.animateTo(
                1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeIn,
              );
              await _downtextController.animateTo(
                1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeIn,
              );

              setState(() {
                dareIndex = dareIndex == randDares.length - 1
                    ? 0
                    : dareIndex + 1;
                _animTypeDare = TurkAnimType.fromRight;
                index = index == randQuizs.length - 1 ? 0 : index + 1;
                _animTypeChoice = TurkAnimType.fromRight;
              });
              _uptextController.value = 0;
              _downtextController.value = 0;

              await Future.delayed(Duration.zero);

              _uptextController.animateTo(
                1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
              );
              _downtextController.animateTo(
                1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
              );
            } else {
              await _uptextController.animateBack(
                0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInCubic,
              );
              await _downtextController.animateBack(
                0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInCubic,
              );
            }
            textDrag = 0;
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber,
              gradient: LinearGradient(
                colors: [TurkStyle().mainColor, Colors.indigo],
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 20, spreadRadius: 3),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    _uptextController.reset();
                    _downtextController.reset();
                    setState(() {
                      _animTypeDare = TurkAnimType.pupup;
                      _animTypeChoice = TurkAnimType.pupup;
                    });

                    await _uptextController.animateTo(
                      1,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInCubic,
                    );
                    await _downtextController.animateBack(
                      0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                    );
                    await _uptextController.animateTo(
                      1,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInCubic,
                    );
                    await _downtextController.animateBack(
                      0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                    );
                    spic_share
                        ? _launchUrl(
                            "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randQuizs[dareIndex]["dare"]}")}",
                          )
                        : SharePlus.instance.share(
                            ShareParams(
                              text:
                                  "*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randQuizs[dareIndex]["dare"]}",
                            ),
                          );
                    _uptextController.value = 0;
                    _downtextController.value = 0;
                  },
                  icon: Icon(Icons.share, size: 35, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            "*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*التحدي*\n* ${randQuizs[dareIndex]["dare"]}",
                      ),
                    );
                  },
                  icon: Icon(Icons.copy, size: 35, color: Colors.white),
                ),
                IconButton(
                  onPressed: () async {
                    _uptextController.reset();
                    _downtextController.reset();
                    setState(() {
                      _animTypeDare = TurkAnimType.toLeft;
                      _animTypeChoice = TurkAnimType.toLeft;
                    });

                    await _uptextController.animateTo(
                      1,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInCubic,
                    );

                    await _downtextController.animateTo(
                      1,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInCubic,
                    );

                    setState(() {
                      if (switchBoth) {
                        if (index == randQuizs.length - 1) {
                          index = -1;
                        }
                        if (dareIndex == randDares.length - 1) {
                          dareIndex = -1;
                        }
                        index++;
                        dareIndex++;
                        _animTypeChoice = TurkAnimType.fromRight;
                        _animTypeDare = TurkAnimType.fromRight;
                      }
                    });

                    _uptextController.value = 0;
                    _downtextController.value = 0;
                    await Future.delayed(Duration.zero);

                    _uptextController.animateTo(
                      1.0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                    );
                    _downtextController.animateTo(
                      1.0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                    );
                  },
                  icon: Icon(
                    Icons.swipe_left_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );

        return _isloading
            ? isDare
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SkiletonSkin(),
                        SkiletonSkin(),
                        if (switchBoth)
                          SkiletonSkin(style: SkiletonStyle.iconsrow),
                      ],
                    )
                  : SkiletonSkin()
            : isDare
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  towCardMethod(context, CardType.choice, rnum, 0),
                  towCardMethod(context, CardType.dare, 0, rnum2),
                  if (switchBoth) iconsRow,
                ],
              )
            : Center(child: towCardMethod(context, CardType.choice, rnum, 0));
      case CardStyle.oneCard:
        return _isloading
            ? SkiletonSkin(heigh: true)
            : Center(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      spic_share
                          ? _launchUrl(
                              "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*ليه السؤال ده؟:*\n* ${randQuizs[index]["dare"]}")}",
                            )
                          : SharePlus.instance.share(
                              ShareParams(
                                text:
                                    '''*السؤال:*\n* ${randQuizs[index]["choice"]}\n\n*ليه السؤال ده؟:*\n* ${randQuizs[index]["dare"]}''',
                              ),
                            );
                    } else if (details.primaryVelocity! < 0) {
                      setState(() {
                        if (index == randQuizs.length - 1) {
                          index = 0;
                        } else {
                          index++;
                        }
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    height: 300,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "images/quiz$rnum.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
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
                                                  color:
                                                      Colors.deepPurpleAccent,
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Text(
                                  randQuizs.isNotEmpty
                                      ? randQuizs[index]["choice"]
                                      : 'لا يوجد بيانات بعد',
                                  style: TextStyle(
                                    fontSize: font_Size,
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // spacing: 50,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      spic_share
                                          ? _launchUrl(
                                              "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}\n\n*ليه السؤال ده؟:*\n* ${randQuizs[index]["dare"]}")}",
                                            )
                                          : SharePlus.instance.share(
                                              ShareParams(
                                                text:
                                                    '''*السؤال:*\n* ${randQuizs[index]["choice"]}\n\n*ليه السؤال ده؟:*\n* ${randQuizs[index]["dare"]}''',
                                              ),
                                            );
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text:
                                              '''*السؤال:*\n* ${randQuizs[index]["choice"]}\n\n*ليه السؤال ده؟:*\n* ${randQuizs[index]["dare"]}''',
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
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
                                      Icons.swipe_left_rounded,
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
                  ),
                ),
              );
    }
  }

  GestureDetector towCardRandowmMethod(
    BuildContext context,
    CardType type,
    int? imagenum1,
    int? imagenum2,
  ) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          spic_share
              ? _launchUrl(
                  type == CardType.dare
                      ? "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*التحدي*\n* ${randDares[dareIndex]["dare"]}")}"
                      : "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}")}",
                )
              : SharePlus.instance.share(
                  ShareParams(
                    text: type == CardType.dare
                        ? "*التحدي*\n* ${randDares[dareIndex]["dare"]}"
                        : "*السؤال* \n* ${randQuizs[index]["choice"]}",
                  ),
                );
        } else if (details.primaryVelocity! < 0) {
          setState(() {
            if (type == CardType.dare) {
              if (dareIndex == randDares.length - 1) {
                dareIndex = 0;
              } else {
                dareIndex++;
              }
            } else {
              if (index == randQuizs.length - 1) {
                index = 0;
              } else {
                index++;
              }
            }
          });
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        height: MediaQuery.of(context).size.height / 3,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  pinImage
                      ? "images/quiz${imagenum2 == 0 ? imagenum1 : imagenum2}.jpg"
                      : "images/quiz${Random().nextInt(10) + 1}.jpg",
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
                    type == CardType.dare ? "تحدي" : "سؤال",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    // choiceText ?? '',
                    type == CardType.dare
                        ? randDares.isNotEmpty
                              ? randDares[dareIndex]["dare"]
                              : 'لا يوجد بيانات بعد'
                        // Choice
                        : randQuizs.isNotEmpty
                        ? randQuizs[index]["choice"]
                        : 'لا يوجد بيانات بعد',
                    style: TextStyle(
                      fontSize: font_Size,
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
                    children: [
                      IconButton(
                        onPressed: () {
                          spic_share
                              ? _launchUrl(
                                  type == CardType.dare
                                      ? "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*التحدي*\n* ${randDares[dareIndex]["dare"]}")}"
                                      : "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}")}",
                                )
                              : SharePlus.instance.share(
                                  ShareParams(
                                    text: type == CardType.dare
                                        ? "*التحدي*\n* ${randDares[dareIndex]["dare"]}"
                                        : "*السؤال* \n* ${randQuizs[index]["choice"]}",
                                  ),
                                );
                        },
                        icon: Icon(Icons.share, size: 35, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: type == CardType.dare
                                  ? "*التحدي*\n* ${randDares[dareIndex]["dare"]}"
                                  : "*السؤال* \n* ${randQuizs[index]["choice"]}",
                            ),
                          );
                        },
                        icon: Icon(Icons.copy, size: 35, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            if (type == CardType.dare) {
                              _animTypeDare = TurkAnimType.toLeft;
                            } else {
                              _animTypeChoice = TurkAnimType.toLeft;
                            }
                          });

                          final controller = type == CardType.dare
                              ? _downtextController
                              : _uptextController;

                          await controller.animateTo(
                            1,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                          );

                          setState(() {
                            if (type == CardType.dare) {
                              dareIndex = dareIndex == randDares.length - 1
                                  ? 0
                                  : dareIndex + 1;
                              _animTypeDare = TurkAnimType.fromRight;
                            } else {
                              index = index == randQuizs.length - 1
                                  ? 0
                                  : index + 1;
                              _animTypeChoice = TurkAnimType.fromRight;
                            }
                            controller.value = 0;
                          });

                          await Future.delayed(Duration.zero);

                          controller.animateTo(
                            1.0,
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeIn,
                          );

                          textDrag = 0;
                        },
                        icon: Icon(
                          Icons.swipe_left_rounded,
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
      ),
    );
  }

  GestureDetector towCardMethod(
    BuildContext context,
    CardType type,
    int? imagenum1,
    int? imagenum2,
  ) {
    final currentAnimType = type == CardType.dare
        ? _animTypeDare
        : _animTypeChoice;

    return GestureDetector(
      onTap: () {
        /* Don't do anything..*/
      },
      onHorizontalDragUpdate: (details) {
        final delta = details.primaryDelta! / MediaQuery.of(context).size.width;

        textDrag += delta;
        textDrag = textDrag.clamp(-1.0, 1.0);

        final controller = type == CardType.dare
            ? _downtextController
            : _uptextController;

        controller.value = textDrag.abs();
        if (textDrag > 0 &&
            (type == CardType.dare
                ? _animTypeDare != TurkAnimType.pupup
                : _animTypeChoice != TurkAnimType.pupup)) {
          setState(() {
            type == CardType.dare
                ? _animTypeDare = TurkAnimType.pupup
                : _animTypeChoice = TurkAnimType.pupup;
          });
        } else if (textDrag < 0 &&
            (type == CardType.dare
                ? _animTypeDare != TurkAnimType.toLeft
                : _animTypeChoice != TurkAnimType.toLeft)) {
          setState(() {
            type == CardType.dare
                ? _animTypeDare = TurkAnimType.toLeft
                : _animTypeChoice = TurkAnimType.toLeft;
          });
        }
      },
      onHorizontalDragEnd: (_) async {
        if (textDrag > swipeThreshold) {
          setState(() {
            if (type == CardType.dare) {
              _animTypeDare = TurkAnimType.pupup;
            } else {
              _animTypeChoice = TurkAnimType.pupup;
            }
          });

          final controller = type == CardType.dare
              ? _downtextController
              : _uptextController;

          await controller.animateTo(
            1.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
          await controller.animateBack(
            0.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeIn,
          );
          spic_share
              ? _launchUrl(
                  type == CardType.dare
                      ? "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*التحدي*\n* ${randQuizs[dareIndex]["dare"]}")}"
                      : "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}")}",
                )
              : SharePlus.instance.share(
                  ShareParams(
                    text: type == CardType.dare
                        ? "*التحدي*\n* ${randQuizs[dareIndex]["dare"]}"
                        : "*السؤال* \n* ${randQuizs[index]["choice"]}",
                  ),
                );
        } else if (textDrag < -swipeThreshold) {
          final controller = type == CardType.dare
              ? _downtextController
              : _uptextController;
          setState(() {
            if (type == CardType.dare) {
              _animTypeDare = TurkAnimType.toLeft;
            } else {
              _animTypeChoice = TurkAnimType.toLeft;
            }
          });

          await controller.animateTo(
            1,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeIn,
          );

          setState(() {
            if (type == CardType.dare) {
              dareIndex = dareIndex == randDares.length - 1 ? 0 : dareIndex + 1;
              _animTypeDare = TurkAnimType.fromRight;
            } else {
              index = index == randQuizs.length - 1 ? 0 : index + 1;
              _animTypeChoice = TurkAnimType.fromRight;
            }
          });
          controller.value = 0;

          await Future.delayed(Duration.zero);

          controller.animateTo(
            1.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
          );
        } else {
          final controller = type == CardType.dare
              ? _downtextController
              : _uptextController;
          await controller.animateBack(
            0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInCubic,
          );
        }
        textDrag = 0;
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  pinImage
                      ? "images/quiz${imagenum2 == 0 ? imagenum1 : imagenum2}.jpg"
                      : "images/quiz${Random().nextInt(10) + 1}.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// بقية محتوى الكارد (نصوص + أزرار)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  type == CardType.dare ? "تحدي" : "سؤال",
                  style: TextStyle(
                    fontSize: 30,
                    shadows: [Shadow(color: Colors.black, blurRadius: 30)],
                  ),
                ),
                ClipRect(
                  child: AnimatedBuilder(
                    animation: type == CardType.dare
                        ? _downtextController
                        : _uptextController,
                    builder: (context, child) {
                      switch (currentAnimType) {
                        case TurkAnimType.pupup:
                          return Transform.scale(
                            scale:
                                1 +
                                Curves.easeOutBack.transform(
                                      type == CardType.dare
                                          ? _downtextController.value
                                          : _uptextController.value,
                                    ) *
                                    0.2,
                            child: child,
                          );

                        case TurkAnimType.fromRight:
                          return Transform.translate(
                            offset: Offset(
                              (1 -
                                      (type == CardType.dare
                                          ? _downtextController.value
                                          : _uptextController.value)) *
                                  200,
                              0,
                            ),
                            child: Opacity(
                              opacity: type == CardType.dare
                                  ? _downtextController.value
                                  : _uptextController.value,
                              child: child,
                            ),
                          );

                        case TurkAnimType.toLeft:
                          return Transform.translate(
                            offset: Offset(
                              -(type == CardType.dare
                                      ? _downtextController.value
                                      : _uptextController.value) *
                                  80,
                              0,
                            ),
                            child: Opacity(
                              opacity:
                                  1 -
                                  (type == CardType.dare
                                      ? _downtextController.value
                                      : _uptextController.value),
                              child: child,
                            ),
                          );
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        type == CardType.dare
                            ? randQuizs[dareIndex]["dare"]
                            : randQuizs[index]["choice"],
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: font_Size,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final controller = type == CardType.dare
                              ? _downtextController
                              : _uptextController;
                          controller.reset();
                          setState(() {
                            if (type == CardType.dare) {
                              _animTypeDare = TurkAnimType.pupup;
                            } else {
                              _animTypeChoice = TurkAnimType.pupup;
                            }
                          });

                          await controller.animateTo(
                            1,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInCubic,
                          );
                          await controller.animateBack(
                            0,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                          );
                          spic_share
                              ? _launchUrl(
                                  type == CardType.dare
                                      ? "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*التحدي*\n* ${randQuizs[dareIndex]["dare"]}")}"
                                      : "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}")}",
                                )
                              : SharePlus.instance.share(
                                  ShareParams(
                                    text: type == CardType.dare
                                        ? "*التحدي*\n* ${randQuizs[dareIndex]["dare"]}"
                                        : "*السؤال* \n* ${randQuizs[index]["choice"]}",
                                  ),
                                );
                          type == CardType.dare
                              ? _downtextController.value = 0
                              : _uptextController.value = 0;
                        },
                        icon: Icon(Icons.share, size: 35, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: type == CardType.dare
                                  ? "*التحدي*\n* ${randQuizs[dareIndex]["dare"]}"
                                  : "*السؤال* \n* ${randQuizs[index]["choice"]}",
                            ),
                          );
                        },
                        icon: Icon(Icons.copy, size: 35, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () async {
                          final controller = type == CardType.dare
                              ? _downtextController
                              : _uptextController;
                          controller.reset();
                          setState(() {
                            if (type == CardType.dare) {
                              _animTypeDare = TurkAnimType.toLeft;
                            } else {
                              _animTypeChoice = TurkAnimType.toLeft;
                            }
                          });

                          await controller.animateTo(
                            1,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInCubic,
                          );

                          setState(() {
                            if (type == CardType.dare) {
                              dareIndex = dareIndex == randDares.length - 1
                                  ? 0
                                  : dareIndex + 1;
                              _animTypeDare = TurkAnimType.fromRight;
                            } else {
                              index = index == randQuizs.length - 1
                                  ? 0
                                  : index + 1;
                              _animTypeChoice = TurkAnimType.fromRight;
                            }
                          });
                          controller.value = 0;

                          await Future.delayed(Duration.zero);

                          controller.animateTo(
                            1.0,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        icon: Icon(
                          Icons.swipe_left_rounded,
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
      ),
    );
  }

  // GestureDetector towCardMethod(
  //   BuildContext context,
  //   CardType type,
  //   int? imagenum1,
  //   int? imagenum2,
  // ) {
  //   return GestureDetector(
  //     onHorizontalDragEnd: (details) {
  //       if (details.primaryVelocity! > 0) {
  //         spic_share
  //             ? _launchUrl(
  //                 type == CardType.dare
  //                     ? "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*التحدي*\n* ${randQuizs[dareIndex]["dare"]}")}"
  //                     : "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}")}",
  //               )
  //             : SharePlus.instance.share(
  //                 ShareParams(
  //                   text: type == CardType.dare
  //                       ? "*التحدي*\n* ${randQuizs[dareIndex]["dare"]}"
  //                       : "*السؤال* \n* ${randQuizs[index]["choice"]}",
  //                 ),
  //               );
  //       } else if (details.primaryVelocity! < 0) {
  //         setState(() {
  //           if (type == CardType.dare) {
  //             if (dareIndex == randDares.length - 1) {
  //               dareIndex = 0;
  //             } else {
  //               dareIndex++;
  //             }
  //           } else {
  //             if (index == randQuizs.length - 1) {
  //               index = 0;
  //             } else {
  //               index++;
  //             }
  //           }
  //         });
  //       }
  //     },
  //     child: Container(
  //       width: double.infinity,
  //       margin: EdgeInsets.all(10),
  //       padding: EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(50)),
  //       ),
  //       height: MediaQuery.of(context).size.height / 3,
  //       child: Stack(
  //         children: [
  //           Positioned.fill(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(20),
  //               child: Image.asset(
  //                 pinImage
  //                     ? "images/quiz${imagenum2 == 0 ? imagenum1 : imagenum2}.jpg"
  //                     : "images/quiz${Random().nextInt(10) + 1}.jpg",
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           Column(
  //             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Center(
  //                 child: Text(
  //                   type == CardType.dare ? "تحدي" : "سؤال",
  //                   style: TextStyle(
  //                     fontSize: 30,
  //                     shadows: [
  //                       Shadow(
  //                         color: Colors.black,
  //                         offset: Offset(1, 1),
  //                         blurRadius: 30,
  //                       ),
  //                     ],
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 5),
  //                 child: Text(
  //                   // choiceText ?? '',
  //                   type == CardType.dare
  //                       ? randQuizs.isNotEmpty
  //                             ? randQuizs[dareIndex]["dare"]
  //                             : 'لا يوجد بيانات بعد'
  //                       // Choice
  //                       : randQuizs.isNotEmpty
  //                       ? randQuizs[index]["choice"]
  //                       : 'لا يوجد بيانات بعد',
  //                   style: TextStyle(
  //                     fontSize: font_Size,
  //                     shadows: [
  //                       Shadow(
  //                         color: Colors.black,
  //                         offset: Offset(1, 1),
  //                         blurRadius: 30,
  //                       ),
  //                     ],
  //                   ),
  //                   textAlign: TextAlign.center,
  //                   textDirection: TextDirection.rtl,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 10.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     IconButton(
  //                       onPressed: () {
  //                         spic_share
  //                             ? _launchUrl(
  //                                 type == CardType.dare
  //                                     ? "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*التحدي*\n* ${randQuizs[dareIndex]["dare"]}")}"
  //                                     : "https://wa.me/$spic_share_text?text=${Uri.encodeComponent("*السؤال* \n* ${randQuizs[index]["choice"]}")}",
  //                               )
  //                             : SharePlus.instance.share(
  //                                 ShareParams(
  //                                   text: type == CardType.dare
  //                                       ? "*التحدي*\n* ${randQuizs[dareIndex]["dare"]}"
  //                                       : "*السؤال* \n* ${randQuizs[index]["choice"]}",
  //                                 ),
  //                               );
  //                       },
  //                       icon: Icon(Icons.share, size: 35, color: Colors.white),
  //                     ),
  //                     IconButton(
  //                       onPressed: () {
  //                         Clipboard.setData(
  //                           ClipboardData(
  //                             text: type == CardType.dare
  //                                 ? "*التحدي*\n* ${randQuizs[dareIndex]["dare"]}"
  //                                 : "*السؤال* \n* ${randQuizs[index]["choice"]}",
  //                           ),
  //                         );
  //                       },
  //                       icon: Icon(Icons.copy, size: 35, color: Colors.white),
  //                     ),
  //                     IconButton(
  //                       onPressed: () {
  //                         setState(() {
  //                           if (type == CardType.dare) {
  //                             if (dareIndex == randDares.length - 1) {
  //                               dareIndex = 0;
  //                             } else {
  //                               dareIndex++;
  //                             }
  //                           } else {
  //                             if (index == randQuizs.length - 1) {
  //                               index = 0;
  //                             } else {
  //                               index++;
  //                             }
  //                           }
  //                         });
  //                       },
  //                       icon: Icon(
  //                         Icons.swipe_left_rounded,
  //                         size: 35,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch URL: $url');
  }
}
