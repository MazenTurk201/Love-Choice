// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/db_helper.dart';
import '../data/adsManager.dart';
import '../modules/appBarRouter.dart';
import '../modules/globalFuncs.dart';
import '../style/styles.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  // BannerAd? _bannerAd;
  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool switch1 = true;
  bool switch2 = false;
  int? metgawzen_password_num;
  bool test = false;
  TextEditingController controler = TextEditingController();
  TextEditingController font_controler = TextEditingController();
  TextEditingController spic_share_controler = TextEditingController();
  List<Map<String, dynamic>> orderItems = [
    {
      "name": "أهل",
      "isSelected": true,
      "dis": "التجمع الحلو والقعدة الأحلى",
      "root": "ahl",
    },
    {
      "name": "شلة",
      "isSelected": true,
      "dis": "يلا بينا نفك الملل",
      "root": "shella",
    },
    {
      "name": "بيستات",
      "isSelected": true,
      "dis": "مين حبيب اخوه؟",
      "root": "bestat",
    },
    {
      "name": "تعارف",
      "isSelected": true,
      "dis": "الصحاب اللي على قلبك",
      "root": "t3arof",
    },
    {
      "name": "كابلز",
      "isSelected": true,
      "dis": "ايدي ف ايدك نرجع البدايات",
      "root": "couples",
    },
    {
      "name": "مخطوبين",
      "isSelected": false,
      "dis": "نفهم بعض قبل الجد",
      "root": "ma5toben",
    },
    {
      "name": "متجوزين",
      "isSelected": false,
      "dis": "يلّا نحيي حُبنا من جديد",
      "root": "metgawzen",
    },
  ];

  @override
  void initState() {
    super.initState();
    loadSettings();
    // _bannerAd = AdHelper.createBanner();
    // BannerAd(
    //   adUnitId: AdHelper.bannerAdUnitId,
    //   size: AdSize.banner,
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _bannerAd = ad as BannerAd;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, error) {
    //       debugPrint("Faild :${error.message}");
    //       ad.dispose();
    //     },
    //   ),
    //   request: AdRequest(),
    // ).load();
  }

  Future<void> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    TurkRewarded.load();
    setState(() {
      isSwitched = pref.getBool('isDare') ?? true;
      isSwitched2 = pref.getBool('switch_both') ?? true;
      isSwitched3 = pref.getBool('pin_image') ?? true;
      // isSwitched2 = pref.getBool('isSwitched2') ?? true;
      List<String>? rawList = pref.getStringList('orderItems');

      orderItems =
          rawList
              ?.map((item) => jsonDecode(item) as Map<String, dynamic>)
              .toList() ??
          [
            {
              "name": "أهل",
              "isSelected": true,
              "dis": "التجمع الحلو والقعدة الأحلى",
              "root": "ahl",
            },
            {
              "name": "شلة",
              "isSelected": true,
              "dis": "يلا بينا نفك الملل",
              "root": "shella",
            },
            {
              "name": "بيستات",
              "isSelected": true,
              "dis": "مين حبيب اخوه؟",
              "root": "bestat",
            },
            {
              "name": "تعارف",
              "isSelected": true,
              "dis": "الصحاب اللي على قلبك",
              "root": "t3arof",
            },
            {
              "name": "مخطوبين",
              "isSelected": true,
              "dis": "نفهم بعض قبل الجد",
              "root": "ma5toben",
            },
            {
              "name": "كابلز",
              "isSelected": false,
              "dis": "ايدي ف ايدك نرجع البدايات",
              "root": "couples",
            },
            {
              "name": "متجوزين",
              "isSelected": false,
              "dis": "يلّا نحيي حُبنا من جديد",
              "root": "metgawzen",
            },
          ];
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
      top: false,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "/main");
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBarRouter(),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.825,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    settingTile(
                      title: "عرض الخيار التاني؟",
                      state: isSwitched,
                      fun: (val) {
                        isSwitched = val;
                        if (!isSwitched) {
                          isSwitched2 = false;
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
                    settingTile(
                      title: "تثبيت الصور؟",
                      state: isSwitched3,
                      fun: (val) {
                        isSwitched3 = val;
                        saveSettings("pin_image", val);
                      },
                    ),
                    SizedBox(
                      height: 20,
                      child: Divider(indent: 30, endIndent: 30),
                    ),
                    InkWell(
                      onDoubleTap: () async {
                        List<Map<String, dynamic>> orderItems = [
                          {
                            "name": "أهل",
                            "isSelected": true,
                            "dis": "التجمع الحلو والقعدة الأحلى",
                            "root": "ahl",
                          },
                          {
                            "name": "شلة",
                            "isSelected": true,
                            "dis": "يلا بينا نفك الملل",
                            "root": "shella",
                          },
                          {
                            "name": "بيستات",
                            "isSelected": true,
                            "dis": "مين حبيب اخوه؟",
                            "root": "bestat",
                          },
                          {
                            "name": "تعارف",
                            "isSelected": true,
                            "dis": "الصحاب اللي على قلبك",
                            "root": "t3arof",
                          },
                          {
                            "name": "مخطوبين",
                            "isSelected": true,
                            "dis": "نفهم بعض قبل الجد",
                            "root": "ma5toben",
                          },
                          {
                            "name": "كابلز",
                            "isSelected": false,
                            "dis": "ايدي ف ايدك نرجع البدايات",
                            "root": "couples",
                          },
                          {
                            "name": "متجوزين",
                            "isSelected": false,
                            "dis": "يلّا نحيي حُبنا من جديد",
                            "root": "metgawzen",
                          },
                        ];
                        final pref = SharedPreferences.getInstance();
                        pref.then((pref) async {
                          await pref.remove('orderItems');
                          await pref.setStringList(
                            'orderItems',
                            orderItems.map((item) => jsonEncode(item)).toList(),
                          );
                        });
                        TurkFuncs().turkToast("تم الاسترجاع");
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "قائمة الأوردر",
                              style: TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 300,
                              child: StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return ReorderableListView(
                                    onReorder: (oldIndex, newIndex) {
                                      setStateDialog(() {
                                        if (newIndex > oldIndex) newIndex -= 1;
                                        final item = orderItems.removeAt(
                                          oldIndex,
                                        );
                                        orderItems.insert(newIndex, item);
                                      });
                                    },
                                    children: [
                                      for (
                                        int index = 0;
                                        index < orderItems.length;
                                        index++
                                      )
                                        CheckboxListTile(
                                          key: ValueKey(
                                            orderItems[index]["name"],
                                          ),
                                          title: Text(
                                            orderItems[index]["name"],
                                            style: TextStyle(
                                              fontFamily: "TurkFont",
                                            ),
                                          ),
                                          value:
                                              orderItems[index]["isSelected"],
                                          onChanged: (bool? value) {
                                            setStateDialog(() {
                                              orderItems[index]["isSelected"] =
                                                  value!;
                                            });
                                          },
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  // [{name: Option 1, isSelected: true}, {name: Option 2, isSelected: true}, {name: Option 4, isSelected: true}, {name: Option 5, isSelected: false}, {name: Option 3, isSelected: false}]
                                  // debugPrint(orderItems);
                                  final pref =
                                      await SharedPreferences.getInstance();
                                  await pref.setStringList(
                                    'orderItems',
                                    orderItems
                                        .map((item) => jsonEncode(item))
                                        .toList(),
                                  );
                                  TurkFuncs().turkToast("تم تغيير الفئات بنجاح");
                                },
                                child: Text(
                                  "حفظ",
                                  style: TextStyle(fontFamily: "TurkFont"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onTap: () {
                        TurkFuncs().turkToast(
                          "دوس مرتين عشان ترجع طبيعي\nدوسة طويلة عشان تعرض الفئات",
                        );
                      },
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.chat_bubble_rounded, size: 40),
                        ),
                        title: Text(
                          "التحكم في عرض الفئات؟",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontFamily: "TurkFont"),
                        ),
                      ),
                    ),
                    InkWell(
                      onLongPress: () async {
                        await TurkFuncs().requestStoragePermission();
                        TurkFuncs().openAllFilesAccessSettings();
                        BackUp_Restore_LoveChoice(false);
                        TurkFuncs().turkToast("تم الاسترجاع");
                      },
                      onDoubleTap: () async {
                        await TurkFuncs().requestStoragePermission();
                        TurkFuncs().openAllFilesAccessSettings();
                        BackUp_Restore_LoveChoice(true);
                        TurkFuncs().turkToast("تم النسخ في ملفات الجهاز");
                        Fluttertoast.showToast(
                          msg:
                              "/storage/emulated/0/Love Choice/user_database.db",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      onTap: () {
                        TurkFuncs().turkToast(
                          "دوس مرتين عشان تنسخ البيانات\nدوسة طويلة عشان تسترجع البيانات",
                        );
                      },
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.backup, size: 40),
                        ),
                        title: Text(
                          "نسخ احتياطي واستعادة؟",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontFamily: "TurkFont"),
                        ),
                      ),
                    ),
                    InkWell(
                      onLongPress: () {
                        downloadDB();
                        TurkFuncs().turkToast("تم التحديث");
                      },
                      onTap: () {
                        TurkFuncs().turkToast("دوسة طويلة عشان تحدث البيانات");
                      },
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.system_update_tv_outlined,
                            size: 40,
                          ),
                        ),
                        title: Text(
                          "تحديث الأسئلة والتحديات؟",
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
                              "مشاركة مخصصة",
                              style: TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 22,
                              ),
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
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'\+'),
                                      ),
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    onSubmitted: (value) async {
                                      final pref =
                                          await SharedPreferences.getInstance();
                                      if (spic_share_controler
                                          .text
                                          .isNotEmpty) {
                                        await pref.setBool("spic_share", true);
                                        await pref.setString(
                                          "spic_share_text",
                                          spic_share_controler.text.trim(),
                                        );
                                        Navigator.pop(context);
                                        spic_share_controler.text = "";
                                        TurkFuncs().turkToast("تم التغيير");
                                      } else {
                                        spic_share_controler.text = "غلط";
                                      }
                                    },
                                    cursorColor: TurkStyle().mainColor,
                                    decoration: InputDecoration(
                                      prefixText: "+ ",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: TurkStyle().mainColor,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: TurkStyle().mainColor,
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
                                    TurkFuncs().turkToast("تم التغيير");
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
                        TurkFuncs().turkToast("تمت اعادة التعيين");
                      },
                      onTap: () {
                        TurkFuncs().turkToast(
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
                              style: TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 22,
                              ),
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
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
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
                                        TurkFuncs().turkToast("تم التغيير");
                                      } else {
                                        font_controler.text = "غلط";
                                      }
                                    },
                                    cursorColor: TurkStyle().mainColor,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: TurkStyle().mainColor,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: TurkStyle().mainColor,
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
                                  final pref =
                                      await SharedPreferences.getInstance();
                                  if (font_controler.text.isNotEmpty) {
                                    await pref.setDouble(
                                      "font_Size",
                                      double.parse(font_controler.text),
                                    );
                                    Navigator.pop(context);
                                    font_controler.text = "";
                                    TurkFuncs().turkToast("تم التغيير");
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
                        TurkFuncs().turkToast("تمت اعادة التعيين");
                      },
                      onTap: () {
                        TurkFuncs().turkToast(
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
                              style: TextStyle(
                                fontFamily: "TurkFont",
                                fontSize: 22,
                              ),
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
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
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
                                        TurkFuncs().turkToast("تم التغيير");
                                      } else {
                                        controler.text = "غلط";
                                      }
                                    },
                                    cursorColor: TurkStyle().mainColor,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: TurkStyle().mainColor,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: TurkStyle().mainColor,
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
                                  final pref =
                                      await SharedPreferences.getInstance();
                                  if (controler.text.isNotEmpty) {
                                    await pref.setInt(
                                      "metgawzen_password_num",
                                      int.parse(controler.text),
                                    );
                                    await pref.setBool('warning18', false);
                                    await pref.setBool(
                                      'metgawzen_password',
                                      true,
                                    );
                                    Navigator.pop(context);
                                    controler.text = "";
                                    TurkFuncs().turkToast("تم التغيير");
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
                        TurkFuncs().turkToast("اتحذف بنجاح");
                      },
                      onTap: () {
                        TurkFuncs().turkToast(
                          "دوس مرتين عشان يتحذف \nدوسة طويلة عشان تغيير",
                        );
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
                    //       debugPrint("dark");
                    //     }
                    //   },
                    // ),
                    Expanded(child: Container()),
                    // SizedBox(height: MediaQuery.of(context).size.height / 25),
                    Divider(endIndent: 30, indent: 30),
                    Text(
                      "MazenTurk © 2025",
                      style: TextStyle(fontSize: 15, fontFamily: "arial"),
                    ),
                    // SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> BackUp_Restore_LoveChoice(bool backup) async {
  if (backup) {
    // 📂 Backup
    Directory? ext_Dir = await getExternalStorageDirectory();
    Directory? extDir = Directory(join(ext_Dir!.path, 'Love Choice'));

    // ملف التطبيق
    File sourceFile = File(join(extDir.path, "user_database.db"));

    // مكان النسخة الاحتياطية (خارجي)
    Directory targetDir = Directory("/storage/emulated/0/Love Choice/");
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    File targetFile = File(join(targetDir.path, "user_database.db"));

    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    await sourceFile.copy(targetFile.path);
  } else {
    // 📂 Restore
    try {
      // غلقها
      await DBHelper.close();

      // ملف النسخة الاحتياطية
      File sourceFile = File(
        "/storage/emulated/0/Love Choice/user_database.db",
      );

      // مسار التطبيق
      Directory? extDir = await getExternalStorageDirectory();
      if (extDir == null) return;

      Directory targetDir = Directory(join(extDir.path, "Love Choice"));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      File targetFile = File(join(targetDir.path, "user_database.db"));

      if (await targetFile.exists()) {
        await targetFile.delete();
      }

      await sourceFile.copy(targetFile.path);
      await DBHelper.init();
    } catch (e) {
      BackUp_Restore_LoveChoice(true);
    }
  }
}

Future<void> downloadDB() async {
  try {
    await DBHelper.close();
    // 1. الرابط
    const url =
        "https://github.com/MazenTurk201/Love-Choice/raw/refs/heads/main/assets/love_choice.db";

    // 2. هات الديركتوري الأساسي
    Directory? extDir = await getExternalStorageDirectory();
    if (extDir == null) return;

    // اعمل فولدر "Love Choice" لو مش موجود
    Directory saveDir = Directory(join(extDir.path, "Love Choice"));
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }

    // 3. نحدد مسار الحفظ
    String filePath = "${saveDir.path}/love_choice.db";
    File file = File(filePath);

    // 4. اعمل داونلود
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // لو الملف موجود امسحه احتياط
      if (await file.exists()) {
        await file.delete();
      }

      // اكتب الجديد
      await file.writeAsBytes(response.bodyBytes, flush: true);
      await DBHelper.init();
    }
  } catch (e) {
    // null;
  }
}
