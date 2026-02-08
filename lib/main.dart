// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'modules/firebase_options.dart';
import 'modules/carddisplay.dart';
import 'data/db_helper.dart';
import 'screens/auth.dart';
import 'screens/home.dart';
import 'screens/gamepage.dart';
import 'screens/onboarding.dart';
import 'screens/onlineChat.dart';
import 'screens/onlineHome.dart';
import 'screens/profile.dart';
import 'screens/setting.dart';
import 'screens/metgawzenPassword.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'style/styles.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await requestNotificationPermission();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("all_users");
  final pref = await SharedPreferences.getInstance();
  // MobileAds.instance.initialize();
  UnityAds.init(
    gameId: '5996823',
    testMode: kDebugMode,
    onComplete: () => print('Unity Ads Initialized'),
    onFailed: (error, message) =>
        print('Unity Ads Initialization Failed: $error $message'),
  );
  // await DBHelper.init();

  runApp(MyApp(skipfirstPage: pref.getBool("skipfirstPage") ?? false));
}

class MyApp extends StatefulWidget {
  final bool skipfirstPage;
  // ignore: use_super_parameters
  const MyApp({Key? key, required this.skipfirstPage}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Love Choice?',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontFamily: "TurkFont",
            color: Colors.white,
          ),
          labelMedium: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          displayMedium: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          titleMedium: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          bodyLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          bodyMedium: TextStyle(
            fontFamily: "TurkFont",
            fontSize: 24,
            color: Colors.white,
          ),
          bodySmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          displayLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          displaySmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          headlineLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          headlineSmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          labelLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          labelSmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          titleLarge: TextStyle(fontFamily: "TurkFont", color: Colors.white),
          titleSmall: TextStyle(fontFamily: "TurkFont", color: Colors.white),
        ),
        tooltipTheme: TurkStyle().themetooltip,
        dialogTheme: DialogThemeData(
          titleTextStyle: TextStyle(
            fontFamily: "TurkFont",
            color: Colors.white,
            fontSize: 24,
          ),
          contentTextStyle: TextStyle(
            fontFamily: "TurkFont",
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: TurkStyle().mainColor,
          titleTextStyle: TextStyle(
            fontFamily: "TurkFont",
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),

      // initialRoute: '/onboarding',
      initialRoute: widget.skipfirstPage ? '/main' : '/onboarding',
      routes: {
        '/main': (ctx) => home(),
        '/ahl': (ctx) =>
            Gamepage(tablee: 'ahl_choices', style: CardStyle.towCard),
        '/metgawzen': (ctx) =>
            Gamepage(tablee: 'metgawzen_choices', style: CardStyle.towCard),
        '/ma5toben': (ctx) =>
            Gamepage(tablee: 'ma5toben_choices', style: CardStyle.oneCard),
        // '/shella': (ctx) =>
        //     Gamepage(tablee: 'shella_choices', style: CardStyle.towCardRandom),
        // '/t3arof': (ctx) =>
        //     Gamepage(tablee: 't3arof_choices', style: CardStyle.towCardRandom),
        // '/couples': (ctx) =>
        //     Gamepage(tablee: 'couples_choices', style: CardStyle.towCardRandom),
        // '/bestat': (ctx) =>
        //     Gamepage(tablee: 'bestat_choices', style: CardStyle.towCardRandom),
        '/shella': (ctx) =>
            Gamepage(tablee: 'shella_choices', style: CardStyle.towCard),
        '/t3arof': (ctx) =>
            Gamepage(tablee: 't3arof_choices', style: CardStyle.towCard),
        '/couples': (ctx) =>
            Gamepage(tablee: 'couples_choices', style: CardStyle.towCard),
        '/bestat': (ctx) =>
            Gamepage(tablee: 'bestat_choices', style: CardStyle.towCard),
        '/profile': (ctx) => profile(),
        '/setting': (ctx) => setting(),
        '/login': (ctx) => AuthPage(),
        '/onlineChat': (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as String;
          return OnlineChatPage(roomId: args);
        },
        '/onlineHome': (ctx) => OnlineHomePage(),
        '/onboarding': (ctx) => onBoarding(),
        '/metgawzen_password': (ctx) => metgawzenPassword(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}

// void requestNotificationPermission() async {
//     // await FirebaseMessaging.instance.requestPermission();
//     var status = await Permission.notification.status;
//   if (!status.isGranted) {
//     status = await Permission.notification.request();
//   }
// }

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
    // var result = await Permission.notification.request();
    // if (result.isPermanentlyDenied) {
    //   openAppSettings(); // بس لو المستخدم رفض بشكل دائم
    // }
  }
}

Future<bool> requestStoragePermission() async {
  // اطلب صلاحية الوصول للتخزين
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    status = await Permission.storage.request();
  }

  // في حالة أندرويد 11+
  // if (status.isDenied || status.isPermanentlyDenied) {
  //   // هنا ممكن تفتح إعدادات التطبيق علشان المستخدم يفعل الصلاحية بنفسه
  //   await openAppSettings();
  //   return false;
  // }

  return status.isGranted;
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
    fontAsset: "fonts/arabic_font.otf",
  );
}
