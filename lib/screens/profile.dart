import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/styles.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _launchUrl(String url) async {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch URL: $url');
      }
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "/main");
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Turk",
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
            backgroundColor: TurkStyle().mainColor,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 30),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("images/MT.png"),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mazen Sameh Sayed (Turk)",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "TurkFontE",
                            shadows: [
                              Shadow(color: Colors.white, blurRadius: 30),
                            ],
                          ),
                        ),
                        Text(
                          "IT Engineer",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "TurkFontE",
                            shadows: [
                              Shadow(color: Colors.white, blurRadius: 30),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 30),
                          child: Center(
                            child: AchivementTurk(
                              title: "Developer",
                              wedth: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(indent: 50, endIndent: 50),
              BuildListTile(icon: Icons.person, text: "مازن سامح سيد"),
              BuildListTile(icon: Icons.info, text: "مهندس شبكات وبرمجيات"),
              InkWell(
                onTap: () {
                  launchUrl(Uri(scheme: 'tel', path: '+201092130013'));
                },
                child: BuildListTile(icon: Icons.phone, text: "رقمي للشكاوي"),
              ),
              InkWell(
                onTap: () {
                  _launchUrl("https://bit.ly/m/MazenTURK");
                },
                child: BuildListTile(icon: Icons.link, text: "موقعي"),
              ),
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

  // ignore: non_constant_identifier_names, strict_top_level_inference
  ListTile BuildListTile({icon, text}) {
    return ListTile(
      leading: Icon(icon, size: 40),
      title: Text(
        text,
        style: TextStyle(fontFamily: "TurkFont"),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
      ),
    );
  }

  Container AchivementTurk({required String title, required int wedth}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: wedth.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: TurkStyle().mainColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        color: TurkStyle().mainColor,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontFamily: "TurkFontE",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
