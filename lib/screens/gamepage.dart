// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, use_super_parameters
import 'package:flutter/material.dart';
import '../modules/appbars.dart';
import '../modules/carddisplay.dart';

class Gamepage extends StatefulWidget {
  final String tablee;
  final String title;
  final CardStyle? style;
  const Gamepage({
    Key? key,
    required this.tablee,
    required this.title,
    this.style = CardStyle.towCard,
  }) : super(key: key);

  @override
  State<Gamepage> createState() => _GamepageState();
}

class _GamepageState extends State<Gamepage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // بنقول للسيستم "لا، متقفلش الصفحة تلقائي"
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return; // لو اتقفلت فعلاً خلاص مش هنعمل حاجة
        }
        // هنا بنعمل اللي إحنا عايزينه لما المستخدم يرجع
        Navigator.pushReplacementNamed(context, "/main");
      },
      child: Scaffold(
        appBar: TurkAppBar(tablee: widget.tablee, title: widget.title),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset("images/main2.jpg", fit: BoxFit.cover),
              ),
              CardsFactory(tablee: widget.tablee, style: widget.style!),
            ],
          ),
        ),
      ),
    );
  }
}
