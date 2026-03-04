// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/toastdata.dart';
import '../style/styles.dart';
import 'authGate.dart';
import 'changelogSheet.dart';

Future<bool> checkRealConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

class TurkDrawer extends StatefulWidget {
  const TurkDrawer({super.key});

  @override
  State<TurkDrawer> createState() => _TurkDrawerState();
}

class _TurkDrawerState extends State<TurkDrawer> {
  // bool onlinestatus = true;
  // bool settingstatus = true;
  bool onlinestatus = true;
  bool settingstatus = true;

  void loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      onlinestatus = pref.getBool('onlinestatus') ?? true;
      settingstatus = pref.getBool('settingstatus') ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    UnityAds.load(
      placementId: 'Rewarded_Android',
      onComplete: (placementId) => debugPrint('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Load Failed $placementId: $error $message'),
    );
    loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (MediaQuery.of(context).size.height - 56.0),
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.175,
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, TurkStyle().mainColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Menu",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "TurkLogo",
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        ),
                      ),
                    ),
                  ),
                  menuDrawerButton(
                    title: 'اعدادات',
                    icon: Icons.settings,
                    url: 'setting',
                    disable: settingstatus,
                  ),
                  menuDrawerButton(
                    title: 'أون لاين',
                    icon: Icons.wifi_rounded,
                    url: 'online',
                    disable: onlinestatus,
                  ),
                  menuDrawerButton(
                    title: 'ملف المطور',
                    icon: Icons.person,
                    url: 'profile',
                  ),
                  menuDrawerButton(
                    title: 'testrive',
                    icon: Icons.person,
                    url: 'testrive',
                  ),
                  menuDrawerButton(
                    title: 'موقعنا',
                    icon: Icons.contacts,
                    url: 'https://mazenturk201.github.io/Love-Choice',
                  ),
                  menuDrawerButton(
                    title: 'شكاوي',
                    icon: Icons.feedback,
                    url: 'https://wa.me/+201092130013?text=Hi+Turk',
                  ),
                  menuDrawerButton(
                    title: 'ادينا نصايح',
                    icon: Icons.rate_review,
                    url: 'rate',
                  ),
                  menuDrawerButton(
                    title: 'اعزمني على قهوة',
                    icon: Icons.coffee,
                    url:
                        'https://mazenturk201.github.io/Love-Choice/make-a-donation.html',
                  ),
                  menuDrawerButton(
                    title: 'سجل التغيرات والشكر',
                    icon: Icons.history_edu_rounded,
                    url: 'changelog',
                  ),
                  Expanded(child: Container()),
                  Divider(endIndent: 30, indent: 30),
                  // SizedBox(height: MediaQuery.of(context).size.height / 11),
                  menuDrawerButton(
                    title: 'شارك لعبتنا',
                    icon: Icons.ios_share,
                    url: 'share',
                  ),
                  menuDrawerButton(
                    title: 'خروج',
                    icon: Icons.exit_to_app,
                    url: '',
                  ),
                  // SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class menuDrawerButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final String url;
  final bool? disable;

  const menuDrawerButton({
    super.key,
    required this.title,
    required this.icon,
    required this.url,
    this.disable,
  });
  @override
  State<menuDrawerButton> createState() => _menuDrawerButtonState();
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map(
        (MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
      )
      .join('&');
}

class _menuDrawerButtonState extends State<menuDrawerButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.url == '') {
          Fluttertoast.showToast(
            msg: exit_tablee[Random().nextInt(exit_tablee.length)],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
            fontAsset: "fonts/arabic_font.otf",
          );
          Future.value(true);
          exit(0);
        } else if (widget.url == 'setting') {
          if (widget.disable == true) {
            UnityAds.showVideoAd(
              placementId: 'Rewarded_Android',
              onStart: (placementId) => debugPrint('Video Ad $placementId started'),
              onClick: (placementId) => debugPrint('Video Ad $placementId click'),
              onSkipped: (placementId) =>
                  debugPrint('Video Ad $placementId skipped'),
              onComplete: (placementId) {
                debugPrint('Video Ad $placementId completed');
                setState(() async {
                  final pref = await SharedPreferences.getInstance();
                  pref.setBool('settingstatus', false);
                  Navigator.pushReplacementNamed(context, "/setting");
                });
              },
              onFailed: (placementId, error, message) =>
                  debugPrint('Video Ad $placementId failed: $error $message'),
            );
            // TurkRewarded.show(
            //   onReward: (rewarded) {
            //     setState(() async {
            //       final pref = await SharedPreferences.getInstance();
            //       await pref.setBool('settingstatus', false);
            //       Navigator.pushReplacementNamed(context, "/setting");
            //     });
            //   },
            // );
          } else {
            Navigator.pushReplacementNamed(context, "/setting");
          }
        } else if (widget.url == 'profile') {
          Navigator.pushReplacementNamed(context, "/profile");
        } else if (widget.url == 'testrive') {
          Navigator.pushReplacementNamed(context, "/testrive");
        } else if (widget.url == 'share') {
          SharePlus.instance.share(
            ShareParams(
              text:
                  '''😴 *زهقت* من الروتين؟\n🔥 *لعبة* `Love Choice` هتغيّر يومك كله!\n\n🎯 تحديات وأسئلة تخليك:\n✔ تصلّح علاقتك 💕\n✔ تكسّر الملل مع أصحابك 😂\n✔ تقرّب أكتر من البارتنر ❤️\n\n🚀 جربها دلوقتي وخلي الضحك شغال طول القعدة 👇\nhttps://mazenturk201.github.io/Love-Choice''',
            ),
          );
        } else if (widget.url == 'rate') {
          Scaffold.of(context).closeDrawer();
          _showRateDialog(context);
        } else if (widget.url == 'changelog') {
          Scaffold.of(context).closeDrawer();
          Scaffold.of(context).showBottomSheet((context) {
            return ChangeLogSheet();
          },);
        } else if (widget.url == 'online') {
          if (await checkRealConnection()) {
            if (widget.disable == true) {
              UnityAds.showVideoAd(
                placementId: 'Rewarded_Android',
                onStart: (placementId) =>
                    debugPrint('Video Ad $placementId started'),
                onClick: (placementId) => debugPrint('Video Ad $placementId click'),
                onSkipped: (placementId) =>
                    debugPrint('Video Ad $placementId skipped'),
                onComplete: (placementId) {
                  debugPrint('Video Ad $placementId completed');
                  setState(() async {
                    final pref = await SharedPreferences.getInstance();
                    pref.setBool('onlinestatus', false);
                    Navigator.pushReplacementNamed(context, "/login");
                  });
                },
                onFailed: (placementId, error, message) =>
                    debugPrint('Video Ad $placementId failed: $error $message'),
              );
              // TurkRewarded.show(
              //   onReward: (rewarded) {

              //   },
              // );
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthGate()));
              // final session = FirebaseAuth.instance.currentUser;
              // if (session != null) {
              //   Navigator.of(context).pushReplacementNamed('/onlineHome');
              // } else {
              //   Navigator.pushReplacementNamed(context, "/login");
              // }
            }
          } else {
            // Navigator.of(context).pop();
            Scaffold.of(context).closeDrawer();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "لازم تكون متصل بالنت",
                  textAlign: TextAlign.right,
                ),
              ),
            );
          }
        } else {
          _launchUrl(widget.url);
        }
      },
      child: ListTile(
        leading: Icon(
          widget.disable == true ? Icons.lock_rounded : widget.icon,
          size: 30,
          color: widget.disable == true
              ? const Color.fromARGB(255, 102, 102, 102)
              : Colors.white,
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "TurkFont",
            color: widget.disable == true
                ? const Color.fromARGB(255, 102, 102, 102)
                : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch URL: $url');
  }
}

final TextEditingController _controller = TextEditingController();

void _showRateDialog(BuildContext context) {
  int uiStars = 0;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      alignment: Alignment.center,
      title: const Text("قيمنا", textAlign: TextAlign.center),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        uiStars = index + 1;
                      });
                    },
                    child: Icon(
                      index < uiStars ? Icons.star : Icons.star_border_outlined,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // نص التقييم
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "اكتب اقتراحك أو تقييمك",
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ],
          );
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            String text = _controller.text;
            launchUrl(
              Uri(
                scheme: 'mailto',
                path: 'maznktr@gmail.com',
                query: encodeQueryParameters(<String, String>{
                  'subject': "Love Choice Game تقييم جديد",
                  'body': "⭐ التقييم: $uiStars من 5\n\nالرسالة:\n$text",
                }),
              ),
            );
            Navigator.pop(context);
          },
          child: const Text("أرسل"),
        ),
      ],
    ),
  );
}
