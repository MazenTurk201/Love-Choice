import 'package:flutter/material.dart';
import 'package:love_choice/modules/appbars.dart';
import '../modules/soon.dart';

final String tablee = "bestat_choices";

class bestat extends StatefulWidget {
  const bestat({super.key});

  @override
  State<bestat> createState() => _bestatState();
}

class _bestatState extends State<bestat> {
  @override
  Widget build(BuildContext context) {
    return soonWidget(tablee: tablee);
  }
}
