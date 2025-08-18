import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import '../modules/drawerr.dart';
import '../modules/buildcard.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

final double currentVersion = 1.0;

Future<void> getVersionText(
  BuildContext context,
  double current_version,
) async {
  try {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/MazenTurk201/Love-Choice/refs/heads/main/version.txt',
      ),
    );
    if (response.statusCode == 200) {
      double version = double.parse(response.body.trim());
      if (version > current_version) {
        // print('🔔 A new version is available: $version');
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "تحديث جديد 🔔",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "TurkFont"),
              textDirection: TextDirection.rtl,
            ),
            content: Text(
              "نسخة جديدة من التطبيق متاحة. الرجاء تحديث التطبيق للاستمتاع بأحدث الميزات.",
              style: TextStyle(fontSize: 15, fontFamily: "TurkFont"),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _launchUrl(
                    'https://github.com/MazenTurk201/Love-Choice/releases/latest',
                  );
                },
                child: Text(
                  "حسناً",
                  style: TextStyle(fontSize: 15, fontFamily: "TurkFont"),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }
      // } else {
      //   print('✅ You are using the latest version: $current_version');
      // }
      // print('✅ Version: $version');
    } else {
      // print(
      //   '❌ Failed to load version. Status code: ${response.statusCode}',
      // );
      null;
    }
  } catch (e) {
    // print('❌ Error: $e');
    null;
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch URL: $url');
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // List<Map<String, String>> data = [
  //   // {"title": "أهل", "subtitle": "التجمع الحلو والقعدة الأحلى", "root": "ahl"},
  //   {
  //     "title": "متجوزين",
  //     "subtitle": "يلّا نحيي حُبنا من جديد",
  //     "root": "metgawzen",
  //   },
  //   {"title": "مخطوبين", "subtitle": "نفهم بعض قبل الجد", "root": "ma5toben"},
  //   {"title": "تعارف", "subtitle": "نجرب نكتشف بعض", "root": "t3arof"},
  //   {
  //     "title": "كوبلز",
  //     "subtitle": "ايدي ف ايدك نرجع البدايات",
  //     "root": "couples",
  //   },
  //   {"title": "بيستات", "subtitle": "مين حبيب اخوه؟", "root": "bestat"},
  //   {"title": "شلة", "subtitle": "يلا بينا نفك الملل", "root": "shella"},
  // ];

  @override
  void initState() {
    super.initState();
    getVersionText(context, currentVersion);
  }

  List<String> exit_tablee = ["مصيرك ترجعلي 😏", "اوروفوار يقلبي", "طب مثا"];
  List<String> ahl_enter_tablee = ["يجمعكم"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Fluttertoast.showToast(
          // msg: "مصيرك ترجعلي 😏",
          msg: exit_tablee[Random().nextInt(exit_tablee.length)],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // exit(0);
        return Future.value(true);
      },
      child: Scaffold(
        drawer: TurkDrawer(),
        appBar: AppBar(
          title: Text(
            "Love Choice",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "TurkLogo",
              fontSize: 35,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "قائمة الخيارات",
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 55, 0, 255),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset("images/main.jpg", fit: BoxFit.cover),
              ),

              // ListView.builder(
              //   itemCount: 3,
              //   // itemCount: data.length / 2,
              //   itemBuilder: (BuildContext context, int index) {
              //     return Container(
              //       margin: EdgeInsets.all(8),
              //       height: 200,
              //       child: Buildcard(
              //         data[index]["title"]!,
              //         data[index]["subtitle"]!,
              //         data[index]["root"]!,
              //       ),
              //     );
              //   },
              // ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    // صف واحد
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Buildcard(
                            "أهل",
                            "التجمع الحلو والقعدة الأحلى",
                            "ahl",
                          ),
                        ),
                      ],
                    ),
                    // صف ثاني
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Buildcard(
                            "متجوزين",
                            "يلّا نحيي حُبنا من جديد",
                            "metgawzen",
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Buildcard(
                            "مخطوبين",
                            "نفهم بعض قبل الجد",
                            "ma5toben",
                          ),
                        ),
                      ],
                    ),
                    // صف ثالث
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Buildcard("تعارف", "نجرب نكتشف بعض", "t3arof"),
                        ),
                        Expanded(
                          flex: 1,
                          child: Buildcard(
                            "كوبلز",
                            "ايدي ف ايدك نرجع البدايات",
                            "couples",
                          ),
                        ),
                      ],
                    ),
                    // صف رابع
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Buildcard(
                            "بيستات",
                            "مين حبيب اخوه؟",
                            "bestat",
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Buildcard(
                            "شلة",
                            "يلا بينا نفك الملل",
                            "shella",
                          ),
                        ),
                      ],
                    ),
                    // نص تحت
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "الحب اختيار، وانا اخترتك ❤️\"",
                        style: TextStyle(
                          fontFamily: "TurkD",
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void requestNotificationPermission() async {
  await FirebaseMessaging.instance.requestPermission();
}

Future<void> showNotification(RemoteMessage message) async {
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'عنوان',
    message.notification?.body ?? 'محتوى',
    NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        icon: 'ic_notification', // ← مهم جدا
      ),
    ),
  );
}
