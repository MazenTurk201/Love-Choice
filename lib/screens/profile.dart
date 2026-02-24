import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:love_choice/modules/appBarRouter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../data/adsManager.dart';
import '../style/styles.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fromleftAnimationController;
  late AnimationController _fromrightAnimationController;

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fromleftAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fromrightAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoAnimationController.forward();
    _logoAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _logoAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _logoAnimationController.forward();
      }
    });
    _fromleftAnimationController.forward();
    _fromrightAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fromleftAnimationController.dispose();
    _fromrightAnimationController.dispose();
    super.dispose();
  }

  Animation<Offset> slideFromLeft(double start, double end) {
    return Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _fromleftAnimationController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> slideFromRight(double start, double end) {
    return Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _fromrightAnimationController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

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
          appBar: AppBarRouter(),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      TurkStyle().mainColor, 
                      Colors.black
                      ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 5,
                  children: [
                    SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, -0.05),
                            end: Offset(0, 0.05),
                          ).animate(
                            CurvedAnimation(
                              parent: _logoAnimationController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.red, blurRadius: 30),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: AssetImage("images/MT.png"),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: slideFromLeft(
                        0.0,
                        0.5,
                      ), // Adjust the interval as needed
                      child: Text(
                        "Mazen Sameh Sayed (Turk)",
                        style: TextStyle(
                          color: TurkStyle().mainColor,
                          fontSize: 25,
                          fontFamily: "TurkFontE",
                          shadows: [
                            Shadow(color: TurkStyle().hoverColor, blurRadius: 30),
                          ],
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: slideFromLeft(
                        0.3,
                        0.5,
                      ), // Adjust the interval as needed
                      child: Text(
                        "IT Engineer",
                        style: TextStyle(
                          color: TurkStyle().mainColor,
                          fontSize: 20,
                          fontFamily: "TurkFontE",
                          shadows: [
                            Shadow(color: TurkStyle().hoverColor, blurRadius: 30),
                          ],
                        ),
                      ),
                    ),
                    AchivementTurk(
                      title: "Developer",
                      wedth: 150,
                    ),
                    Divider(indent: 50, endIndent: 50),
                    SlideTransition(
                      position: slideFromRight(0.3, 0.5),
                      child: BuildListTile(
                        icon: Icons.person,
                        text: "مازن سامح سيد",
                      ),
                    ),
                    SlideTransition(
                      position: slideFromLeft(0.5, 0.7),
                      child: BuildListTile(
                        icon: Icons.info,
                        text: "مهندس شبكات وبرمجيات",
                      ),
                    ),
                    SlideTransition(
                      position: slideFromRight(
                        0.7,
                        0.9,
                      ), // Adjust the interval as needed
                      child: InkWell(
                        onTap: () {
                          launchUrl(Uri(scheme: 'tel', path: '+201092130013'));
                        },
                        child: BuildListTile(
                          icon: Icons.phone,
                          text: "رقمي للشكاوي",
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: slideFromLeft(
                        0.8,
                        1,
                      ), // Adjust the interval as needed
                      child: InkWell(
                        onTap: () {
                          _launchUrl("https://bit.ly/m/MazenTURK");
                        },
                        child: BuildListTile(icon: Icons.link, text: "موقعي"),
                      ),
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
