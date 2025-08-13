import 'package:flutter/material.dart';
import 'package:love_choice/modules/appbars.dart';

import '../modules/soon.dart';

final String tablee = "shella_choices";

class shella extends StatefulWidget {
  const shella({super.key});

  @override
  State<shella> createState() => _shellaState();
}

class _shellaState extends State<shella> {
  @override
  Widget build(BuildContext context) {
    return soonWidget(tablee: tablee);
  }
}
