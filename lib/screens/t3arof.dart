import 'package:flutter/material.dart';
import 'package:love_choice/modules/appbars.dart';

import '../modules/soon.dart';

final String tablee = "t3arof_choices";

class t3arof extends StatefulWidget {
  const t3arof({super.key});

  @override
  State<t3arof> createState() => _t3arofState();
}

class _t3arofState extends State<t3arof> {
  @override
  Widget build(BuildContext context) {
    return soonWidget(tablee: tablee);
  }
}
