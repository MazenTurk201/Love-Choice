// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:love_choice/modules/carddisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/appbars.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';
import '../data/db_helper.dart';
import 'package:redacted/redacted.dart';

final String tablee = 'ahl_choices';

class ahl extends StatefulWidget {
  const ahl({super.key});

  @override
  State<ahl> createState() => _ahlState();
}

class _ahlState extends State<ahl> {
  bool isDare = true;
  bool switch_both = false;
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
      isDare = pref.getBool('isDare') ?? true;
      switch_both = pref.getBool('switch_both') ?? false;
      pin_image = pref.getBool('pin_image') ?? true;
    });
  }

  List<Map<String, dynamic>> randquizs = [];
  List<Map<String, dynamic>> randdares = [];
  int index = 0;
  int dareindex = 0;
  String textQuiz = '';
  String textDare = '';

  void getRandUsers() async {
    final data = await DBHelper.getRandUsers(tablee);
    final data2 = await DBHelper.getRandUsers(tablee);
    setState(() {
      randquizs = data;
      randdares = data2;
      textQuiz = randquizs[index]['choice'] ?? '';
      textDare = randdares[dareindex]['dare'] ?? '';
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
              CardsFactory(tablee: tablee),
              // isDare
              //     ? Column(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           CardsFactory(
              //             tablee: tablee,
              //             type: CardType.choice,
              //             imageNumber: rnum,
              //             style: CardStyle.towCardRandom,
              //             switchBoth: switch_both,
              //           ),
              //           CardsFactory(
              //             tablee: tablee,
              //             type: CardType.dare,
              //             imageNumber: rnum2,
              //             style: CardStyle.towCardRandom,
              //             switchBoth: switch_both,
              //           ),
              //         ],
              //       )
              //     : Center(
              //         child: CardsFactory(
              //           tablee: tablee,
              //           type: CardType.choice,
              //           imageNumber: rnum,
              //           style: CardStyle.towCardRandom,
              //           switchBoth: false,
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }

  // Container cardDisplay(int random_number, String type, bool switch_both) {
  //   return Container(
  //     width: double.infinity,
  //     margin: EdgeInsets.all(10),
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(50)),
  //     ),
  //     height: 200,
  //     child: Stack(
  //       children: [
  //         Positioned.fill(
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(20),
  //             child: Image.asset(
  //               "images/quiz$random_number.jpg",
  //               fit: BoxFit.cover,
  //             ).redacted(context: context, redact: _isloading),
  //           ),
  //         ),
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Center(
  //               child: Text(
  //                 type == "dare" ? "تحدي" : "سؤال",
  //                 style: TextStyle(
  //                   fontSize: 30,
  //                   shadows: [
  //                     Shadow(
  //                       color: Colors.black,
  //                       offset: Offset(1, 1),
  //                       blurRadius: 30,
  //                     ),
  //                   ],
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ).redacted(context: context, redact: _isloading),
  //             ),
  //             _isloading
  //                 ? Text(
  //                     'fetching data',
  //                     style: TextStyle(fontSize: 24),
  //                     textAlign: TextAlign.center,
  //                     textDirection: TextDirection.rtl,
  //                   ).redacted(context: context, redact: _isloading)
  //                 : Text(
  //                     // choiceText ?? '',
  //                     type == "dare"
  //                         ? randdares.isNotEmpty
  //                               ? randdares[dareindex][type]
  //                               : 'لا يوجد بيانات بعد'
  //                         // Choice
  //                         : randquizs.isNotEmpty
  //                         ? randquizs[index][type]
  //                         : 'لا يوجد بيانات بعد',
  //                     style: TextStyle(
  //                       fontSize: 24,
  //                       shadows: [
  //                         Shadow(
  //                           color: Colors.black,
  //                           offset: Offset(1, 1),
  //                           blurRadius: 30,
  //                         ),
  //                       ],
  //                     ),
  //                     textAlign: TextAlign.center,
  //                     textDirection: TextDirection.rtl,
  //                   ),
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 10.0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   _isloading
  //                       ? Container(
  //                           width: 50,
  //                           height: 50,
  //                         ).redacted(context: context, redact: _isloading)
  //                       : IconButton(
  //                           onPressed: () {
  //                             SharePlus.instance.share(
  //                               ShareParams(
  //                                 text: type == "dare"
  //                                     ? textDare.toString()
  //                                     : textQuiz.toString(),
  //                               ),
  //                             );
  //                           },
  //                           icon: Icon(
  //                             Icons.share,
  //                             size: 35,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                   _isloading
  //                       ? Container(
  //                           width: 50,
  //                           height: 50,
  //                         ).redacted(context: context, redact: _isloading)
  //                       : IconButton(
  //                           onPressed: () {
  //                             Clipboard.setData(
  //                               ClipboardData(
  //                                 text: type == "dare"
  //                                     ? textDare.toString()
  //                                     : textQuiz.toString(),
  //                               ),
  //                             );
  //                           },
  //                           icon: Icon(
  //                             Icons.copy,
  //                             size: 35,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                   _isloading
  //                       ? Container(
  //                           width: 50,
  //                           height: 50,
  //                         ).redacted(context: context, redact: _isloading)
  //                       : IconButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               if (switch_both) {
  //                                 if (index == randquizs.length - 1) {
  //                                   index = -1;
  //                                 }
  //                                 if (dareindex == randdares.length - 1) {
  //                                   dareindex = -1;
  //                                 }
  //                                 index++;
  //                                 dareindex++;
  //                                 textQuiz = randquizs[index]['choice'] ?? '';
  //                                 textDare = randquizs[index]['dare'] ?? '';
  //                               } else {
  //                                 if (type == "dare") {
  //                                   if (dareindex == randdares.length - 1) {
  //                                     dareindex = 0;
  //                                     textDare = randquizs[0]['dare'] ?? '';
  //                                   } else {
  //                                     dareindex++;
  //                                     textDare =
  //                                         randquizs[dareindex]['dare'] ?? '';
  //                                   }
  //                                 } else {
  //                                   if (index == randquizs.length - 1) {
  //                                     index = 0;
  //                                     textQuiz = randquizs[0]['choice'] ?? '';
  //                                   } else {
  //                                     index++;
  //                                     textQuiz =
  //                                         randquizs[index]['choice'] ?? '';
  //                                   }
  //                                 }
  //                               }
  //                             });
  //                           },
  //                           icon: Icon(
  //                             Icons.swipe_right,
  //                             size: 35,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
