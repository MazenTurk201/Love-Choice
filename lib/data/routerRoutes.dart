import 'package:flutter/material.dart';

import '../modules/carddisplay.dart';
import '../modules/soon.dart';
import '../screens/auth.dart';
import '../screens/gamepage.dart';
import '../screens/home.dart';
import '../screens/metgawzenPassword.dart';
import '../screens/onboarding.dart';
import '../screens/onlineChat.dart';
import '../screens/onlineChatInfo.dart';
import '../screens/onlineHome.dart';
import '../screens/profile.dart';
import '../screens/setting.dart';

Map<String, Widget Function(BuildContext)> allRoutes = {
  '/main': (ctx) => home(),
  '/ahl': (ctx) => Gamepage(tablee: 'ahl_choices', title: 'أهل'),
  '/metgawzen': (ctx) =>
      Gamepage(tablee: 'metgawzen_choices', title: 'متجوزين'),
  '/ma5toben': (ctx) => Gamepage(
    tablee: 'ma5toben_choices',
    title: 'مخطوبين',
    style: CardStyle.oneCard,
  ),
  '/shella': (ctx) => Gamepage(tablee: 'shella_choices', title: 'شِلّا'),
  '/t3arof': (ctx) => Gamepage(tablee: 't3arof_choices', title: 'تعارف'),
  '/couples': (ctx) => Gamepage(tablee: 'couples_choices', title: 'كابلز'),
  '/bestat': (ctx) => Gamepage(tablee: 'bestat_choices', title: 'بستات'),
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
};
