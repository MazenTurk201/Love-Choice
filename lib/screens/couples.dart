import 'package:flutter/material.dart';
import 'package:love_choice/modules/appbars.dart';
import '../modules/soon.dart';

final String tablee = "couples_choices";

class couples extends StatefulWidget {
  const couples({super.key});

  @override
  State<couples> createState() => _couplesState();
}

class _couplesState extends State<couples> {
  @override
  Widget build(BuildContext context) {
    return soonWidget(tablee: tablee);
  }
}
