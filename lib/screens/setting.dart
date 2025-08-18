import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = pref.getBool('isDare') ?? true;
      isSwitched2 = pref.getBool('switch_both') ?? false;
      isSwitched3 = pref.getBool('pin_image') ?? true;
      // isSwitched2 = pref.getBool('isSwitched2') ?? true;
    });
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings(String key, bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  ListTile settingTile({
    required String title,
    required bool state,
    required Function(bool) fun,
  }) => ListTile(
    leading: Switch(
      value: state,
      onChanged: (value) {
        setState(() {
          fun(value);
          saveSettings(title, state);
        });
      },
      // onChanged: (value) {
      //   setState(() {
      //     // state = value;
      //     fun(value);
      // });
      // },
    ),
    title: Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(fontFamily: "TurkFont"),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "/main");
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Setting",
              style: TextStyle(fontFamily: "TurkLogo", fontSize: 35),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/main");
              },
            ),
            backgroundColor: Color.fromARGB(255, 55, 0, 255),
            elevation: 4,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              settingTile(
                title: "عرض الخيار التاني؟",
                state: isSwitched,
                fun: (val) {
                  isSwitched = val;
                  // if (val) {
                  //   print("lol");
                  // }
                  saveSettings("isDare", val);
                },
              ),
              settingTile(
                title: "تغيرهم مع بعض؟",
                state: isSwitched2,
                fun: (val) {
                  isSwitched2 = val;
                  saveSettings("switch_both", val);
                },
              ),
              settingTile(
                title: "تثبيت الصور؟",
                state: isSwitched3,
                fun: (val) {
                  isSwitched3 = val;
                  saveSettings("pin_image", val);
                },
              ),
              // settingTile(
              //   title: "تغيرهم مع بعض؟",
              //   state: isSwitched2,
              //   fun: (val) {
              //     isSwitched2 = val;
              //     if (!val) {
              //       print("dark");
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
