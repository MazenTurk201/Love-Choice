import 'dart:ffi';

import 'package:d_dialog/d_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:love_choice/data/adsManager.dart';
import 'package:love_choice/modules/popMenu.dart';
import 'package:love_choice/style/styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OnlineHomePage extends StatefulWidget {
  const OnlineHomePage({super.key});

  @override
  State<OnlineHomePage> createState() => _OnlineHomePageState();
}

class _OnlineHomePageState extends State<OnlineHomePage> {
  List chats = [];
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadchats();
    _bannerAd = AdHelper.createBanner();
  }

  void loadchats() async {
    final data = await supabase
        .from('messages')
        .select("room_id")
        .eq('sender', supabase.auth.currentUser!.id);
    // لو عايز تشيل التكرار بعد ما الداتا تيجي
    final uniqueRooms = data.map((e) => e['room_id']).toSet().toList();
    setState(() {
      chats = uniqueRooms;
    });
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
              showDialog(
                builder: (context) => DDialog(title: Text("data")),
                context: context,
              );
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                supabase.auth.signOut();
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
              const SizedBox(height: 10),
              AdHelper.TurkAD(_bannerAd),
              // استخدمنا Expanded عشان الليست تاخد باقي المساحة المتاحة ومتضربش
              Expanded(
                child: chats.isEmpty
                    ? const Center(
                        child: Text("مفيش رسايل لسه يا كبير"),
                      ) // لو الليستة فاضية
                    : ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (BuildContext context, int index) {
                          final currentRoomId =
                              chats[index]; // نمسك الروم الحالية
                          return ListTile(
                            title: Text(
                              currentRoomId,
                              style: const TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 24,
                                color: Colors
                                    .white, // تأكد ان الخلفية مش بيضا عشان الكلام يبان
                              ),
                              // تأكد ان كلاس TextUtils شغال معاك تمام
                              textDirection: TextUtils.getTextDirection(
                                currentRoomId,
                              ),
                            ),
                            subtitle: Text(
                              "تع ندردش",
                              style: const TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textDirection: TextUtils.getTextDirection(
                                "تع ندردش",
                              ),
                            ),
                            trailing: Icon(
                              Icons.chat,
                              size: 40,
                              color: TurkStyle().mainColor,
                            ),
                            onTap: () {
                              // التصحيح هنا: بنبعت اسم الروم المتغيرة مش الثابتة
                              Navigator.of(context).pushNamed(
                                '/onlineChat',
                                arguments: currentRoomId,
                              );
                            },
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("تفاصيل"),
                                content: const SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      Text("مسح المحادثة؟"),
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
