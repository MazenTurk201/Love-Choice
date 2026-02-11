import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_dialog/d_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:love_choice/modules/popMenu.dart';
import 'package:love_choice/style/styles.dart';
import 'package:share_plus/share_plus.dart';
import '../data/room_service.dart';
import '../modules/drawerr.dart';

final firebase = FirebaseFirestore.instance;

class OnlineHomePage extends StatefulWidget {
  const OnlineHomePage({super.key});

  @override
  State<OnlineHomePage> createState() => _OnlineHomePageState();
}

class _OnlineHomePageState extends State<OnlineHomePage> {
  List<Map<String, dynamic>> chats = [];

  @override
  void initState() {
    super.initState();
    loadchats();
    // var myRooms = RoomService().getMyGroups();
  }

  void loadchats() async {
    final myRooms = await RoomService().getMyGroups();

    // بعد ما الداتا جت، نقدر نحطها في المتغير عادي
    if (mounted) {
      setState(() {
        chats = List<Map<String, dynamic>>.from(myRooms);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String disName =
        FirebaseAuth.instance.currentUser!.displayName ??
        FirebaseAuth.instance.currentUser!.email!.split("@")[0];
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "/main");
          return Future.value(false);
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              TextEditingController nameController = TextEditingController();
              TextEditingController disController = TextEditingController();
              TextEditingController avatarController = TextEditingController();
              showDialog(
                builder: (context) => AlertDialog(
                  title: Text("لمة جديدة؟"),
                  content: SizedBox(
                    height: 250,
                    child: Column(
                      children: [
                        Text("اسم الجروب"),
                        TextField(controller: nameController),
                        Text("وصف الجروب"),
                        TextField(controller: disController),
                        Text("صورة الجروب"),
                        TextField(controller: avatarController),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await RoomService().createRoom(
                          context,
                          nameController.text.isNotEmpty
                              ? nameController.text
                              : "جروب جديد",
                          disController.text.isNotEmpty
                              ? disController.text
                              : "منور اللعبة",
                          avatarController.text.isNotEmpty
                              ? avatarController.text
                              : null,
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        loadchats();
                      },
                      child: Text("كرييت"),
                    ),
                  ],
                ),
                context: context,
              );
            },
            tooltip: "عمل جروب",
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/main");
              },
            ),
            title: Text("Welcome $disName"),
            centerTitle: true,
            backgroundColor: TurkStyle().mainColor,
            actions: [TurkPopMenu(popMenuType: TurkPopMenuType.home)],
          ),
          body: Column(
            children: [
              Expanded(
                child: chats.isEmpty
                    ? const Center(
                        child: Text("مفيش جروبات لسه يا كبير"),
                      ) // لو الليستة فاضية
                    : ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading:
                                TextUtils.getTextDirection(
                                      chats[index]['dis'],
                                    ) ==
                                    TextDirection.ltr
                                ? Hero(
                                  tag: "avatar_${chats[index]['id']}",
                                  child: CircleAvatar(
                                      backgroundColor: randomMaterialColor(),
                                      backgroundImage:
                                          chats[index]['avatar_url'] != null
                                          ? NetworkImage(
                                              chats[index]['avatar_url'],
                                            )
                                          : null,
                                      // لو مفيش صورة، حط أول حرف من اسم الجروب
                                      child: chats[index]['avatar_url'] == null
                                          ? Text(
                                              chats[index]['name'][0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                )
                                : null,
                            title: Hero(
                              tag: "name_${chats[index]['id']}",
                              child: Text(
                                chats[index]['name'],
                                style: const TextStyle(
                                  fontFamily: "TurkFont",
                                  fontSize: 24,
                                  color: Colors
                                      .white, // تأكد ان الخلفية مش بيضا عشان الكلام يبان
                                ),
                                // تأكد ان كلاس TextUtils شغال معاك تمام
                                textDirection: TextUtils.getTextDirection(
                                  chats[index]['name'],
                                ),
                              ),
                            ),
                            subtitle: Text(
                              chats[index]['dis'],
                              style: const TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textDirection: TextUtils.getTextDirection(
                                chats[index]['dis'],
                              ),
                            ),
                            trailing:
                                TextUtils.getTextDirection(
                                      chats[index]['dis'],
                                    ) ==
                                    TextDirection.rtl
                                ? Hero(
                                  tag: "avatar_${chats[index]['id']}",
                                  child: CircleAvatar(
                                      backgroundColor: randomMaterialColor(),
                                      backgroundImage:
                                          chats[index]['avatar_url'] != null
                                          ? NetworkImage(
                                              chats[index]['avatar_url'],
                                            )
                                          : null,
                                      // لو مفيش صورة، حط أول حرف من اسم الجروب
                                      child: chats[index]['avatar_url'] == null
                                          ? Text(
                                              chats[index]['name'][0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                )
                                : null,
                            onTap: () {
                              // التصحيح هنا: بنبعت اسم الروم المتغيرة مش الثابتة
                              // return OnlineChatPage(roomId: args, roomName: roomName, roomImage: roomImage);
                              Navigator.of(context).pushNamed(
                                '/onlineChat',
                                arguments: {
                                  'roomId': chats[index]['id'],
                                  'roomName': chats[index]['name'],
                                  'roomBio': chats[index]['dis'],
                                  'roomImage': chats[index]['avatar_url'],
                                },
                              );
                            },
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "تفاصيل الجروب",
                                  style: TextStyle(fontFamily: "TurkFont"),
                                  textAlign: TextAlign.center,
                                ),
                                content: SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          SharePlus.instance.share(
                                            ShareParams(
                                              text:
                                                  "تعال الروم بتاعنا\nhttps://mazenturk201.github.io/Love-Choice/invite/?roomid=${chats[index]['id']}",
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("مشاركة الجروب"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          RoomService().leaveGroup(
                                            chats[index]['id'],
                                          );
                                          setState(() {
                                            chats.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "خروج من الجروب",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      // هنا ممكن تحط زرار حذف
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
