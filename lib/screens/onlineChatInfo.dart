import 'package:flutter/material.dart';

class Onlinechatinfo extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String roomBio;
  final String? roomImage;
  const Onlinechatinfo({
    super.key,
    required this.roomId,
    required this.roomName,
    this.roomImage, required this.roomBio,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(
          '/onlineChat',
          arguments: {
            'roomId': roomId,
            'roomName': roomName,
            'roomBio': roomBio,
            'roomImage': roomImage,
          },
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(title: Hero(tag: "name_$roomId", child: Text(roomName))),
        body: Center(child: Text(roomBio)),
      ),
    );
  }
}
