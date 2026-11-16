import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:love_choice/modules/globalFuncs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_update/in_app_update.dart';
import '../data/db_helper.dart';
import '../data/toastdata.dart';
import '../modules/appBarRouter.dart';
import '../modules/drawerr.dart';
import '../modules/buildcard.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
}

Future<void> getVersionText(BuildContext context) async {
  try {
    final info = await InAppUpdate.checkForUpdate();

    if (!context.mounted) return;

    // استكمال تحديث فوري بدأ ولم يكتمل
    if (info.updateAvailability ==
        UpdateAvailability.developerTriggeredUpdateInProgress) {
      await InAppUpdate.performImmediateUpdate();
      return;
    }

    if (info.updateAvailability != UpdateAvailability.updateAvailable) {
      return;
    }

    if (!info.immediateUpdateAllowed && !info.flexibleUpdateAllowed) {
      debugPrint("No update type is currently allowed.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          "تحديث جديد 🔔",
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: "TurkFont"),
        ),
        content: const Text(
          "نسخة جديدة من التطبيق متاحة! "
          "حدّث التطبيق واستمتع بأحدث الميزات والتحسينات.",
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 15, fontFamily: "TurkFont"),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              try {
                // الأولوية للتحديث الفوري
                if (info.immediateUpdateAllowed) {
                  await InAppUpdate.performImmediateUpdate();
                } else if (info.flexibleUpdateAllowed) {
                  StreamSubscription<InstallStatus>? subscription;

                  subscription = InAppUpdate.installUpdateListener.listen(
                    (status) async {
                      if (status == InstallStatus.downloaded) {
                        await subscription?.cancel();

                        try {
                          await InAppUpdate.completeFlexibleUpdate();
                        } catch (e) {
                          debugPrint("Complete update error: $e");
                        }
                      }
                    },
                    onError: (e) {
                      debugPrint("Update listener error: $e");
                    },
                  );

                  final result = await InAppUpdate.startFlexibleUpdate();

                  if (result != AppUpdateResult.success) {
                    await subscription.cancel();
                  }
                }
              } catch (e) {
                debugPrint("Update error: $e");
              }
            },
            child: const Text(
              "يلا بينا 🚀",
              style: TextStyle(fontSize: 15, fontFamily: "TurkFont"),
            ),
          ),
        ],
      ),
    );
  } catch (e) {
    debugPrint("In-App Update error: $e");
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<Map<String, dynamic>> orderItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        getVersionText(context);
      }
    });
    loadSettings();
    DBHelper.init();
  }

  Future<void> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
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
      // debugPrint(orderItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = orderItems
        .where((item) => item["isSelected"] == true)
        .toList();
    return PopScope(
      canPop: false, // بنقول للسيستم "لا، متقفلش الصفحة تلقائي"
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return; // لو اتقفلت فعلاً خلاص مش هنعمل حاجة
        }
        TurkFuncs().turkToast(
          exit_tablee[Random().nextInt(exit_tablee.length)],
        );
        SystemNavigator.pop();
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          drawer: TurkDrawer(),
          appBar: AppBarRouter(),
          backgroundColor: Colors.black,
          // bottomSheet: ChangeLogSheet(),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset("images/main.jpg", fit: BoxFit.cover),
              ),
              selectedItems.isEmpty
                  ? Center(child: Text("روح أعرض حاجة من الاعدادات"))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height / 4 - 62.5,
                            ),
                            child: Buildcard(
                              selectedItems[0]["name"],
                              selectedItems[0]["dis"],
                              selectedItems[0]["root"],
                              true,
                            ),
                          ),
                        ),
                        if (orderItems.length > 1)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: selectedItems.length - 1,
                            itemBuilder: (context, index) {
                              return selectedItems[index + 1]["isSelected"]
                                  ? Buildcard(
                                      selectedItems[index + 1]["name"],
                                      selectedItems[index + 1]["dis"],
                                      selectedItems[index + 1]["root"],
                                      false,
                                    )
                                  : SizedBox.shrink();
                            },
                          ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "الحب اختيار، وانا اخترتك ❤️\"",
                            style: TextStyle(
                              fontFamily: "TurkD",
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
