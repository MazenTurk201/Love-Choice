// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TurkDrawer extends StatelessWidget {
  const TurkDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              // color: Color.fromARGB(255, 55, 0, 255),
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color.fromARGB(255, 55, 0, 255)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                // color: Color.fromARGB(255, 55, 0, 255),
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
            ),
            menuDrawerButton(
              title: 'ملف المطور',
              icon: Icons.person,
              url: 'profile',
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
              url: 'donation',
            ),
            Expanded(child: Container()),
            Divider(endIndent: 30, indent: 30),
            SizedBox(height: 10),
            menuDrawerButton(
              title: 'شارك لعبتنا',
              icon: Icons.ios_share,
              url: 'share',
            ),
            menuDrawerButton(title: 'خروج', icon: Icons.exit_to_app, url: ''),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class menuDrawerButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final String url;

  const menuDrawerButton({
    super.key,
    required this.title,
    required this.icon,
    required this.url,
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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.url == '') {
          exit(0);
        } else if (widget.url == 'setting' ||
            widget.url == 'profile' ||
            widget.url == 'donation') {
          Navigator.pushReplacementNamed(context, "/${widget.url}");
        } else if (widget.url == 'share') {
          SharePlus.instance.share(
            ShareParams(
              text: '''ازاي مستحمل الملل ده؟؟
تعال اعرفك ازاي تشيل الملل ده او ترجع علاقاتك مع الناس اللي بتحبهم وتقوي العلاقة
لعبة Love Choice هي انسب حل ليك مش بس فيها العاب للملل لا دي بتنقذك في حجات كتيرررر!!

مثلا عندك :-
• ازاي تصلح علاقتك مع مراتك؟
• ازاي تجمع شمل عيلتك؟
• ازاي تعرف البارتنر (شريكك) كويس قبل الجد؟
• ازاي تتعرض على شخص بصورة احسن وتفك الملل؟
• ازاي تفرفش الشلة وتخلص الوقت مع بعض؟
ازي وازاي وازاي وحجات تانية كتير في اللعبة ومش مقتصرة على كده بس مش هحرق عليك حمل بسرعة وضحك غيرك

https://mazenturk201.github.io/Love-Choice''',
            ),
          );
        } else if (widget.url == 'rate') {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              alignment: Alignment.center,
              title: Text("قيمنا", textAlign: TextAlign.center),
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => InkWell(
                        onTap: () {
                          print(index);
                        },
                        child: const Icon(Icons.star_border_outlined),
                      ),
                    ),
                  ),

                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "اكتب اقتراحك أو تقييمك",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: ElevatedButton(
                    onPressed: () {
                      String text = _controller.text;
                      launchUrl(
                        Uri(
                          scheme: 'mailto',
                          path: 'maznktr@gmail.com',
                          query: encodeQueryParameters(<String, String>{
                            'subject': "Love Choice Game",
                            'body': text,
                          }),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text("أرسل"),
                  ),
                ),
              ],
            ),
          );
        } else {
          _launchUrl(widget.url);
        }
      },
      child: ListTile(
        leading: Icon(widget.icon, size: 30),
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "TurkFont"),
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
