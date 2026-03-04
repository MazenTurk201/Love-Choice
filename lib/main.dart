// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'data/room_service.dart';
import 'modules/authGate.dart';
import 'modules/globalFuncs.dart';
import 'modules/soon.dart';
import 'modules/firebase_options.dart';
import 'modules/carddisplay.dart';
import 'screens/auth.dart';
import 'screens/home.dart';
import 'screens/gamepage.dart';
import 'screens/onboarding.dart';
import 'screens/onlineChat.dart';
import 'screens/onlineChatInfo.dart';
import 'screens/onlineHome.dart';
import 'screens/profile.dart';
import 'screens/setting.dart';
import 'screens/metgawzenPassword.dart';
import 'style/styles.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TurkFuncs().requestStoragePermission();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(TurkFuncs().firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("all_users");
  final pref = await SharedPreferences.getInstance();
  UnityAds.init(
    gameId: '5996823',
    testMode: kDebugMode,
    onComplete: () => debugPrint('Unity Ads Initialized'),
    onFailed: (error, message) =>
        debugPrint('Unity Ads Initialization Failed: $error $message'),
  );
  final initialUri = await AppLinks().getInitialLink();

  runApp(
    MyApp(
      skipfirstPage: pref.getBool("skipfirstPage") ?? false,
      initialDeepLink: initialUri,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool skipfirstPage;
  final Uri? initialDeepLink;
  // ignore: use_super_parameters
  const MyApp({Key? key, required this.skipfirstPage, this.initialDeepLink})
    : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>?
  _linkSubscription;

  @override
  void initState() {
    super.initState();

    // إشعارات Firebase
    FirebaseMessaging.onMessage.listen((message) {
      TurkFuncs().showNotification(message);
    });

    // تشغيل الـ Deep Links
    _initDeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialDeepLink != null) {
        _handleLink(widget.initialDeepLink!);
      }
    });
  }

  @override
  void dispose() {
    // مهم جداً نقفل الـ stream لما التطبيق يقفل زي الـ example
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleLink(uri);
      },
      onError: (err) {
        debugPrint('Error on Link Stream: $err');
      },
    );
  }

  Uri? pendingDeepLink;

  void _handleLink(Uri uri) async {
    pendingDeepLink = uri;

    final roomId = uri.queryParameters['roomid'];
    if (roomId == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await RoomService().joinGroup(roomId, user.uid);
      TurkFuncs().turkToast("منور الدنيا 🥳❤️.");
    }
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    // 👇 Cold start + Deep Link
    if (pendingDeepLink != null) {
      // final uri = pendingDeepLink!;
      pendingDeepLink = null;

      // final roomId = uri.queryParameters['roomid'];

      return MaterialPageRoute(builder: (_) => AuthGate());
    }

    // 👇 تشغيل عادي
    if (widget.skipfirstPage) {
      return MaterialPageRoute(builder: (_) => home());
    } else {
      return MaterialPageRoute(builder: (_) => onBoarding());
    }
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
      onGenerateRoute: _onGenerateRoute,

      // // initialRoute: '/onboarding',
      // initialRoute: widget.skipfirstPage ? '/main' : '/onboarding',
      routes: {
        '/main': (ctx) => home(),
        '/ahl': (ctx) => Gamepage(
          tablee: 'ahl_choices',
          title: 'أهل',
        ),
        '/metgawzen': (ctx) => Gamepage(
          tablee: 'metgawzen_choices',
          title: 'متجوزين',
        ),
        '/ma5toben': (ctx) => Gamepage(
          tablee: 'ma5toben_choices',
          title: 'مخطوبين',
          style: CardStyle.oneCard,
        ),
        '/shella': (ctx) => Gamepage(
          tablee: 'shella_choices',
          title: 'شِلّا',
        ),
        '/t3arof': (ctx) => Gamepage(
          tablee: 't3arof_choices',
          title: 'تعارف',
        ),
        '/couples': (ctx) => Gamepage(
          tablee: 'couples_choices',
          title: 'كابلز',
        ),
        '/bestat': (ctx) => Gamepage(
          tablee: 'bestat_choices',
          title: 'بستات',
        ),
        '/profile': (ctx) => profile(),
        '/setting': (ctx) => setting(),
        '/login': (ctx) => AuthPage(),
        '/onlineChat': (ctx) {
          // بنستقبل الـ arguments كـ Map عشان فيها كذا معلومة
          final Map<String, dynamic> args =
              ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;

          return OnlineChatPage(
            roomId: args['roomId'], // تأكد إن الـ key ده هو اللي بتبعت بيه
            roomName: args['roomName'],
            roomBio: args['roomBio'],
            roomImage: args['roomImage'],
          );
        },
        '/onlineHome': (ctx) => OnlineHomePage(),
        '/onlineChatInfo': (ctx) {
          final Map<String, dynamic> args =
              ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;

          return Onlinechatinfo(
            roomId: args['roomId'], // تأكد إن الـ key ده هو اللي بتبعت بيه
            roomName: args['roomName'],
            roomBio: args['roomBio'],
            roomImage: args['roomImage'],
          );
        },
        '/onboarding': (ctx) => onBoarding(),
        '/metgawzen_password': (ctx) => metgawzenPassword(),
        '/soon': (ctx) => soonWidget(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
