import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
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

  void _handleLink(Uri uri) {
    print('اللينك وصل يا ريس: $uri');

    // دلوقت اللينك جاي كده: .../Love-Choice?roomid=201201
    // فمش محتاجين نعمل split ولا وجع قلب، الـ Uri class هتفهم لوحدها

    // بنسأل الـ URI: هل معاك query parameter اسمه roomid؟
    String? roomId = uri.queryParameters['roomid'];

    if (roomId != null) {
      print('مسكنا الـ ID يا ترك: $roomId');

      // هنا بقى الكود بتاعك عشان تدخل الروم
      // navigateToRoom(roomId);
    } else {
      print('اللينك سليم بس مفيهوش roomid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text('مستنيين اللينك يا ترك...'))),
    );
  }
}
