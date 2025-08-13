import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home.dart';
import 'screens/ahl.dart';
import 'screens/metgawzen.dart';
import 'screens/ma5toben.dart';
import 'screens/shella.dart';
import 'screens/t3arof.dart';
import 'screens/couples.dart';
import 'screens/bestat.dart';
import 'screens/profile.dart';
import 'screens/setting.dart';
import 'screens/donation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("all_users");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    // FirebaseMessaging.instance.getToken().then((token) {
    //   print("🔑 Token: $token");
    // });

    FirebaseMessaging.onMessage.listen((message) {
      // print("📲 إشعار جديد: ${message.notification?.title}");
      showNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: "TurkFont",
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: Color.fromARGB(155, 90, 45, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontFamily: "TurkFont",
            fontSize: 13,
            // fontWeight: FontWeight.bold,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          waitDuration: Duration(milliseconds: 300),
          showDuration: Duration(seconds: 3),
          preferBelow: false, // يظهر فوق العنصر
        ),
      ),

      initialRoute: '/main',
      // initialRoute: '/',
      routes: {
        '/main': (ctx) => home(),
        '/ahl': (ctx) => ahl(),
        '/metgawzen': (ctx) => metgawzen(),
        '/ma5toben': (ctx) => ma5toben(),
        '/shella': (ctx) => shella(),
        '/t3arof': (ctx) => t3arof(),
        '/couples': (ctx) => couples(),
        '/bestat': (ctx) => bestat(),
        '/profile': (ctx) => profile(),
        '/setting': (ctx) => setting(),
        '/donation': (ctx) => donation(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}
