// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules/firebase_options.dart';
import 'screens/ahl.dart';
import 'screens/bestat.dart';
import 'screens/couples.dart';
import 'screens/donation.dart';
import 'screens/home.dart';
import 'screens/ma5toben.dart';
import 'screens/metgawzen.dart';
import 'screens/onboarding.dart';
import 'screens/profile.dart';
import 'screens/setting.dart';
import 'screens/shella.dart';
import 'screens/t3arof.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("all_users");
  final pref = await SharedPreferences.getInstance();

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
    requestNotificationPermission();
    FirebaseMessaging.onMessage.listen((message) {
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
          preferBelow: false,
        ),
      ),

      // initialRoute: '/onboarding',
      initialRoute: widget.skipfirstPage ? '/main' : '/onboarding',
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
        '/onboarding': (ctx) => onBoarding(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}
