import 'dart:ffi';

import 'package:d_dialog/d_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:love_choice/data/adsManager.dart';
import 'package:love_choice/modules/popMenu.dart';
import 'package:love_choice/style/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../data/room_service.dart';
import '../modules/drawerr.dart';

final supabase = Supabase.instance.client;

class OnlineHomePage extends StatefulWidget {
  const OnlineHomePage({super.key});

  @override
  State<OnlineHomePage> createState() => _OnlineHomePageState();
}

class _OnlineHomePageState extends State<OnlineHomePage> {
  List<Map<String, dynamic>> chats = [];
  // BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadchats();
    UnityAds.load(
      placementId: 'ABNR',
      onComplete: (placementId) => print('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
    // var myRooms = RoomService().getMyGroups();
    // print("الجروبات بتاعتي: $myRooms");
    // _bannerAd = AdHelper.createBanner();
  }

  void loadchats() async {
    final myRooms = await RoomService().getMyGroups();

    // بعد ما الداتا جت، نقدر نحطها في المتغير عادي
    if (mounted) {
      setState(() {
        chats = List<Map<String, dynamic>>.from(myRooms);
      });
    }

    // final data = await supabase
    //     .from('messages')
    //     .select("room_id")
    //     .eq('sender', supabase.auth.currentUser!.id);
    // // لو عايز تشيل التكرار بعد ما الداتا تيجي
    // final uniqueRooms = data.map((e) => e['room_id']).toSet().toList();

    // [{id: c2e769e2-87ec-4a28-940e-6a7cc1f33069, name: شلة ترك الجديدة, created_at: 2025-11-25T16:34:05.927307+00:00, dis: وادي تجربة, avatar_url: null, room_members: [{role: admin, room_id: c2e769e2-87ec-4a28-940e-6a7cc1f33069, user_id: 1f347697-7e63-4268-b465-8174c3fb92cf, joined_at: 2025-11-25T16:34:06.134329+00:00}]}]

    // setState(() {
    //   // chats = uniqueRooms;
    // });
  }

  @override
  Widget build(BuildContext context) {
    String disName =
        supabase.auth.currentUser!.userMetadata?['display_name'] ??
        supabase.auth.currentUser!.userMetadata?['name'] ??
        supabase.auth.currentUser!.userMetadata?['full_name'] ??
        supabase.auth.currentUser!.email!.split("@")[0];
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
                  title: Text("صناعة جروب"),
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
                      child: Text("انشاء"),
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
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: UnityBannerAd(
                  placementId: 'ABNR',
                  onLoad: (placementId) => print('Banner loaded: $placementId'),
                  onClick: (placementId) =>
                      print('Banner clicked: $placementId'),
                  onShown: (placementId) => print('Banner shown: $placementId'),
                  onFailed: (placementId, error, message) =>
                      print('Banner Ad $placementId failed: $error $message'),
                ),
              ),
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
                                ? CircleAvatar(
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
                                  )
                                : null,
                            title: Text(
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
                                ? CircleAvatar(
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
                                  )
                                : null,
                            onTap: () {
                              // التصحيح هنا: بنبعت اسم الروم المتغيرة مش الثابتة
                              Navigator.of(context).pushNamed(
                                '/onlineChat',
                                arguments: chats[index]['id'],
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
