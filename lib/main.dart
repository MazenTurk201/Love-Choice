// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:love_choice/modules/carddisplay.dart';
import 'package:love_choice/screens/gamepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules/firebase_options.dart';
import 'screens/donation.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'screens/profile.dart';
import 'screens/setting.dart';

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
        '/ahl': (ctx) =>
            Gamepage(tablee: 'ahl_choices', style: CardStyle.towCard),
        '/metgawzen': (ctx) =>
            Gamepage(tablee: 'metgawzen_choices', style: CardStyle.towCard),
        '/ma5toben': (ctx) =>
            Gamepage(tablee: 'ma5toben_choices', style: CardStyle.oneCard),
        '/shella': (ctx) =>
            Gamepage(tablee: 'shella_choices', style: CardStyle.towCardRandom),
        '/t3arof': (ctx) =>
            Gamepage(tablee: 't3arof_choices', style: CardStyle.towCardRandom),
        '/couples': (ctx) =>
            Gamepage(tablee: 'couples_choices', style: CardStyle.towCardRandom),
        '/bestat': (ctx) =>
            Gamepage(tablee: 'bestat_choices', style: CardStyle.towCardRandom),
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
