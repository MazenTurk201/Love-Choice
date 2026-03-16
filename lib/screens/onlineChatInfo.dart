import 'package:flutter/material.dart';

import '../style/styles.dart';

class Onlinechatinfo extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String roomBio;
  final String? roomImage;
  const Onlinechatinfo({
    super.key,
    required this.roomId,
    required this.roomName,
    this.roomImage,
    required this.roomBio,
  });
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // بنقول للسيستم "لا، متقفلش الصفحة تلقائي"
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return; // لو اتقفلت فعلاً خلاص مش هنعمل حاجة
        }
        Navigator.of(context).pushReplacementNamed(
          '/onlineChat',
          arguments: {
            'roomId': roomId,
            'roomName': roomName,
            'roomBio': roomBio,
            'roomImage': roomImage,
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: "name_$roomId",
            child: Material(
              color: Colors.transparent,
              child: Text(
                roomName,
                textDirection: TextUtils.getTextDirection(roomName),
              ),
            ),
          ),
        ),
        body: Center(child: Text(roomBio)),
      ),
    );
  }
}
