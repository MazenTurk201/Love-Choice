// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool switch1 = true;
  bool switch2 = false;
  int? metgawzen_password_num;
  TextEditingController controler = TextEditingController();
  TextEditingController font_controler = TextEditingController();
  TextEditingController spic_share_controler = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = pref.getBool('isDare') ?? true;
      isSwitched2 = pref.getBool('switch_both') ?? true;
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
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              settingTile(
                title: "عرض الخيار التاني؟",
                state: isSwitched,
                fun: (val) {
                  isSwitched = val;
                  if (!isSwitched) {
                    isSwitched2 = false; // يقفل التاني كمان
                    saveSettings("switch_both", val);
                  }
                  saveSettings("isDare", val);
                },
              ),
              settingTile(
                title: "التغيير مع بعض؟",
                state: isSwitched2,
                fun: isSwitched
                    ? (val) {
                        isSwitched2 = val;
                        saveSettings("switch_both", val);
                      }
                    : (val) {},
              ),
              // settingTile(
              //   title: "أخفاء التغيير مع بعض؟",
              //   state: isSwitched2,
              //   fun: (val) {
              //     isSwitched2 = val;
              //     saveSettings("switch_both", val);
              //   },
              // ),
              settingTile(
                title: "تثبيت الصور؟",
                state: isSwitched3,
                fun: (val) {
                  isSwitched3 = val;
                  saveSettings("pin_image", val);
                },
              ),
              SizedBox(height: 20, child: Divider(indent: 30, endIndent: 30)),
              InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "مشاركة مخصصة",
                        style: TextStyle(fontFamily: "TurkFont", fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            Text(
                              "شوف هتبعت لـ مين؟",
                              style: TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\+')),
                              ],
                              keyboardType: TextInputType.numberWithOptions(),
                              onSubmitted: (value) async {
                                final pref =
                                    await SharedPreferences.getInstance();
                                if (spic_share_controler.text.isNotEmpty) {
                                  await pref.setBool("spic_share", true);
                                  await pref.setString(
                                    "spic_share_text",
                                    spic_share_controler.text.trim(),
                                  );
                                  Navigator.pop(context);
                                  spic_share_controler.text = "";
                                  turkToast("تم التغيير");
                                } else {
                                  spic_share_controler.text = "غلط";
                                }
                              },
                              cursorColor: Color.fromARGB(255, 55, 0, 255),
                              decoration: InputDecoration(
                                prefixText: "+ ",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 55, 0, 255),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 55, 0, 255),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                                hint: Text(
                                  "201092130013",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                label: Text(
                                  "الرقم برمز الدولة",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: "TurkFont",
                                  ),
                                ),
                              ),
                              cursorHeight: 30,
                              style: TextStyle(fontFamily: "TurkFont"),
                              textAlign: TextAlign.center,
                              controller: spic_share_controler,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final pref = await SharedPreferences.getInstance();
                            if (spic_share_controler.text.isNotEmpty) {
                              await pref.setBool("spic_share", true);
                              await pref.setString(
                                "spic_share_text",
                                spic_share_controler.text.trim(),
                              );
                              Navigator.pop(context);
                              spic_share_controler.text = "";
                              turkToast("تم التغيير");
                            } else {
                              spic_share_controler.text = "غلط";
                            }
                          },
                          child: Text(
                            "تغيير",
                            style: TextStyle(fontFamily: "TurkFont"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDoubleTap: () async {
                  final pref = await SharedPreferences.getInstance();
                  await pref.setBool("spic_share", false);
                  await pref.setString("spic_share_text", "");
                  turkToast("تمت اعادة التعيين");
                },
                onTap: () {
                  turkToast(
                    "دوس مرتين عشان اعادة التعيين \nدوسة طويلة عشان الاضافة",
                  );
                },
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.numbers_rounded, size: 40),
                  ),
                  title: Text(
                    "مشاركة مخصصة للواتساب؟",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: "TurkFont"),
                  ),
                ),
              ),
              InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "تغيير حجم الخط",
                        style: TextStyle(fontFamily: "TurkFont", fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            Text(
                              "شوف هتغير لـ ايه؟",
                              style: TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              keyboardType: TextInputType.numberWithOptions(),
                              onSubmitted: (value) async {
                                final pref =
                                    await SharedPreferences.getInstance();
                                if (font_controler.text.isNotEmpty) {
                                  await pref.setDouble(
                                    "font_Size",
                                    double.parse(font_controler.text),
                                  );
                                  Navigator.pop(context);
                                  font_controler.text = "";
                                  turkToast("تم التغيير");
                                } else {
                                  font_controler.text = "غلط";
                                }
                              },
                              cursorColor: Color.fromARGB(255, 55, 0, 255),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 55, 0, 255),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 55, 0, 255),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                                hint: Text(
                                  "الطبيعي 24",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                label: Text(
                                  "ظبط الخط على كيفك",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: "TurkFont",
                                  ),
                                ),
                              ),
                              cursorHeight: 30,
                              style: TextStyle(fontFamily: "TurkFont"),
                              textAlign: TextAlign.center,
                              controller: font_controler,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final pref = await SharedPreferences.getInstance();
                            if (font_controler.text.isNotEmpty) {
                              await pref.setDouble(
                                "font_Size",
                                double.parse(font_controler.text),
                              );
                              Navigator.pop(context);
                              font_controler.text = "";
                              turkToast("تم التغيير");
                            } else {
                              font_controler.text = "غلط";
                            }
                          },
                          child: Text(
                            "تغيير",
                            style: TextStyle(fontFamily: "TurkFont"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDoubleTap: () async {
                  final pref = await SharedPreferences.getInstance();
                  await pref.setDouble("font_Size", 24);
                  turkToast("تمت اعادة التعيين");
                },
                onTap: () {
                  turkToast(
                    "دوس مرتين عشان اعادة التعيين \nدوسة طويلة عشان تغيير",
                  );
                },
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.format_size_rounded, size: 40),
                  ),
                  title: Text(
                    "تغيير حجم الخط؟",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: "TurkFont"),
                  ),
                ),
              ),
              InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "تغيير باسورد المتجوزين",
                        style: TextStyle(fontFamily: "TurkFont", fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            Text(
                              "شوف هتغير لـ ايه؟",
                              style: TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              keyboardType: TextInputType.numberWithOptions(),
                              onSubmitted: (value) async {
                                final pref =
                                    await SharedPreferences.getInstance();
                                if (controler.text.isNotEmpty) {
                                  await pref.setInt(
                                    "metgawzen_password_num",
                                    int.parse(controler.text),
                                  );
                                  Navigator.pop(context);
                                  controler.text = "";
                                  turkToast("تم التغيير");
                                } else {
                                  controler.text = "غلط";
                                }
                              },
                              cursorColor: Color.fromARGB(255, 55, 0, 255),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 55, 0, 255),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 55, 0, 255),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                                hint: Text(
                                  "Password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white70),
                                ),
                                label: Text(
                                  "منورين",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: "TurkFont",
                                  ),
                                ),
                              ),
                              cursorHeight: 30,
                              style: TextStyle(fontFamily: "TurkFont"),
                              textAlign: TextAlign.center,
                              controller: controler,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final pref = await SharedPreferences.getInstance();
                            if (controler.text.isNotEmpty) {
                              await pref.setInt(
                                "metgawzen_password_num",
                                int.parse(controler.text),
                              );
                              await pref.setBool('warning18', false);
                              await pref.setBool('metgawzen_password', true);
                              Navigator.pop(context);
                              controler.text = "";
                              turkToast("تم التغيير");
                            } else {
                              controler.text = "غلط";
                            }
                          },
                          child: Text(
                            "تغيير",
                            style: TextStyle(fontFamily: "TurkFont"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDoubleTap: () async {
                  final pref = await SharedPreferences.getInstance();
                  await pref.remove("metgawzen_password_num");
                  await pref.remove("metgawzen_password");
                  await pref.setBool("warning18", true);
                  turkToast("اتحذف بنجاح");
                },
                onTap: () {
                  turkToast("دوس مرتين عشان يتحذف \nدوسة طويلة عشان تغيير");
                },
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.password_rounded, size: 40),
                  ),
                  title: Text(
                    "حذف الباسورد؟",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: "TurkFont"),
                  ),
                ),
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
              Expanded(child: Container()),
              Divider(endIndent: 30, indent: 30),
              Text(
                "MazenTurk © 2025",
                style: TextStyle(fontSize: 15, fontFamily: "arial"),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void turkToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
      fontAsset: "fonts/arabic_font.otf",
    );
  }
}
