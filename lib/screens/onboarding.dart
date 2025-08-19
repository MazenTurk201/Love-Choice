import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../modules/onboardingPageBuilder.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  final controller = PageController();
  bool isListPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isListPage = index == 2);
            },
            children: [
              OnboardingPageBuilder(
                lottie: "",
                title: "عطل فني",
                discribtion: "بلا بلا بلا",
                link: "",
                colors: [Colors.black, Colors.indigo],
              ),
              OnboardingPageBuilder(
                lottie: "assets/animation/MoneyTransfer.json",
                title: "دعم المطور",
                discribtion: "بلا بلا بلا",
                link:
                    "https://mazenturk201.github.io/Love-Choice/make-a-donation.html",
                colors: [Colors.black, Colors.indigo],
              ),
              OnboardingPageBuilder(
                lottie: "assets/animation/Error 404.json",
                title: "عطل فني",
                discribtion: "بلا بلا بلا",
                link: "https://wa.me/+201092130013?text=Hi+Turk",
                colors: [Colors.black, Colors.indigo],
              ),
            ],
          ),
        ),
        bottomSheet: isListPage
            ? TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(25),
                  ),
                ),
                child: Text("يلا بينا", style: TextStyle(fontSize: 24)),
                onPressed: () async {
                  final pref = await SharedPreferences.getInstance();
                  pref.setBool("skipfirstPage", true);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacementNamed("/main");
                },
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => controller.jumpToPage(2),
                      child: Text("تخطي"),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: JumpingDotEffect(verticalOffset: 1),
                        onDotClicked: (index) => controller.animateToPage(
                          index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      child: Text("تمام"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
