import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:love_choice/data/db_helper.dart';
import 'package:love_choice/data/room_service.dart';
import 'package:love_choice/screens/auth.dart';
import 'package:love_choice/screens/onlineChat.dart';
import 'package:love_choice/screens/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/toastdata.dart';
import '../modules/drawerr.dart';
import '../modules/buildcard.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../style/styles.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
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
                  downloadDB();
                },
                child: Text(
                  "يلا بينا",
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
  late AppLinks _appLinks;
  List<Map<String, dynamic>> orderItems = [];

  @override
  void initState() {
    super.initState();
    getVersionText(context, currentVersion);
    loadSettings();
    DBHelper.init();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    // دي عشان لو التطبيق كان مقفول واتفتح عن طريق اللينك
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleLink(uri);
      }
    });

    // دي عشان لو التطبيق شغال في الخلفية واللينك اتداس عليه
    _appLinks.uriLinkStream.listen(
      (uri) {
        _handleLink(uri);
      },
      onError: (err) {
        print('يا ساتر، حصل إيرور: $err');
      },
    );
  }

  void _handleLink(Uri uri) async {
    // مثال:
    // lovechoice://Love-Choice?roomid=201201

    final roomId = uri.queryParameters['roomid'];

    if (roomId == null) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // المستخدم عامل Login
      await RoomService().joinGroup(roomId, user.uid);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnlineChatPage(roomId: roomId)),
      );
    } else {
      // مش عامل Login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  Future<void> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      List<String>? rawList = pref.getStringList('orderItems');

      orderItems =
          rawList
              ?.map((item) => jsonDecode(item) as Map<String, dynamic>)
              .toList() ??
          [
            {
              "name": "أهل",
              "isSelected": true,
              "dis": "التجمع الحلو والقعدة الأحلى",
              "root": "ahl",
            },
            {
              "name": "شلة",
              "isSelected": true,
              "dis": "يلا بينا نفك الملل",
              "root": "shella",
            },
            {
              "name": "بيستات",
              "isSelected": true,
              "dis": "مين حبيب اخوه؟",
              "root": "bestat",
            },
            {
              "name": "تعارف",
              "isSelected": true,
              "dis": "الصحاب اللي على قلبك",
              "root": "t3arof",
            },
            {
              "name": "مخطوبين",
              "isSelected": true,
              "dis": "نفهم بعض قبل الجد",
              "root": "ma5toben",
            },
            {
              "name": "كابلز",
              "isSelected": false,
              "dis": "ايدي ف ايدك نرجع البدايات",
              "root": "couples",
            },
            {
              "name": "متجوزين",
              "isSelected": false,
              "dis": "يلّا نحيي حُبنا من جديد",
              "root": "metgawzen",
            },
          ];
      // print(orderItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = orderItems
        .where((item) => item["isSelected"] == true)
        .toList();
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
            backgroundColor: TurkStyle().mainColor,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset("images/main.jpg", fit: BoxFit.cover),
              ),
              selectedItems.isEmpty
                  ? Center(child: Text("روح أعرض حاجة من الاعدادات"))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Buildcard(
                            selectedItems[0]["name"],
                            selectedItems[0]["dis"],
                            selectedItems[0]["root"],
                            true,
                          ),
                        ),
                        if (orderItems.length > 1)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: selectedItems.length - 1,
                            itemBuilder: (context, index) {
                              return selectedItems[index + 1]["isSelected"]
                                  ? Buildcard(
                                      selectedItems[index + 1]["name"],
                                      selectedItems[index + 1]["dis"],
                                      selectedItems[index + 1]["root"],
                                      false,
                                    )
                                  : SizedBox.shrink();
                            },
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
    id: message.hashCode,
    title: message.notification?.title ?? 'عنوان',
    body: message.notification?.body ?? 'محتوى',
    notificationDetails: NotificationDetails(
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

  // if (await Permission.manageExternalStorage.request().isGranted) {
  //   return true;
  // } else {
  //   openAppSettings(); // يفتح الإعدادات يدويًا
  //   return false;
  // }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  if (androidInfo.version.sdkInt < 30) {
    var status = await Permission.storage.request();
    return status.isGranted;
  } else {
    // أندرويد 11 أو أحدث
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      return true;
    } else {
      openAppSettings();
      return false;
    }
  }
}
