import 'package:d_dialog/d_dialog.dart';
import 'package:flutter/material.dart';
import 'package:love_choice/modules/popMenu.dart';
import 'package:love_choice/style/styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OnlineHomePage extends StatelessWidget {
  const OnlineHomePage({super.key});

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
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                ListTile(
                  // leading: Icon(Icons.person),
                  title: Text(
                    "شات 1",
                    style: TextStyle(
                      fontFamily: "TurkFont",
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textDirection: TextUtils.getTextDirection("شات 1"),
                  ),
                  subtitle: Text(
                    "تع ندردش",
                    style: TextStyle(fontFamily: "TurkFont", fontSize: 14),
                    textDirection: TextUtils.getTextDirection("تع ندردش"),
                  ),
                  trailing: Icon(Icons.chat, size: 40, color: Colors.white),
                  onTap: () => Future.delayed(Duration.zero, () {
                    Navigator.of(
                      // ignore: use_build_context_synchronously
                      context,
                    ).pushNamed('/onlineChat', arguments: 'room1');
                  }),
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("data"),
                      content: SizedBox(
                        height: 200,
                        child: Column(
                          children: [Text("data"), Text("data"), Text("data")],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
