// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'data/room_service.dart';
import 'data/routerRoutes.dart';
import 'modules/authGate.dart';
import 'modules/globalFuncs.dart';
import 'modules/firebase_options.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'style/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  TurkFuncs().requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
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
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    // إشعارات Firebase
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
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
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: _onGenerateRoute,
      routes: allRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
