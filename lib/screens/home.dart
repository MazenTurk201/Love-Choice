import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:love_choice/data/db_helper.dart';
import '../data/toastdata.dart';
import '../modules/drawerr.dart';
import '../modules/buildcard.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

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
  @override
  void initState() async {
    super.initState();
    getVersionText(context, currentVersion);
    openAllFilesAccessSettings();
   await DBHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
          Fluttertoast.showToast(
            msg: exit_tablee[Random().nextInt(exit_tablee.length)],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
            fontAsset: "fonts/arabic_font.otf",
          );
        return Future.value(true);
      },
      child: SafeArea(
        top: false,
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
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset("images/main.jpg", fit: BoxFit.cover),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Buildcard("أهل", "التجمع الحلو والقعدة الأحلى", "ahl", true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Buildcard(
                        "متجوزين",
                        "يلّا نحيي حُبنا من جديد",
                        "metgawzen",
                        false,
                      ),
                      Buildcard(
                        "مخطوبين",
                        "نفهم بعض قبل الجد",
                        "ma5toben",
                        false,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Buildcard("تعارف", "نجرب نكتشف بعض", "t3arof", false),
                      Buildcard(
                        "كوبلز",
                        "ايدي ف ايدك نرجع البدايات",
                        "couples",
                        false,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Buildcard("بيستات", "مين حبيب اخوه؟", "bestat", false),
                      Buildcard("شلة", "يلا بينا نفك الملل", "shella", false),
                    ],
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
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

Future<bool> openAllFilesAccessSettings() async {
  // if (Platform.isAndroid) {
  //   const intent = AndroidIntent(
  //     action: 'android.settings.MANAGE_ALL_FILES_ACCESS_PERMISSION',
  //   );
  //   await intent.launch();
  //   turkToast("اديلنا صلاحيات الملفات عشان التحديثات");
  // }
  if (await Permission.manageExternalStorage.request().isGranted) {
    return true;
  } else {
    openAppSettings(); // يفتح الإعدادات يدويًا
    return false;
  }
}
