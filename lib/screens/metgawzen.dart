import 'package:flutter/material.dart';
import 'package:love_choice/modules/appbars.dart';

import '../modules/soon.dart';

final String tablee = "metgawzen_choices";

class metgawzen extends StatefulWidget {
  const metgawzen({super.key});

  @override
  State<metgawzen> createState() => _metgawzenState();
}

class _metgawzenState extends State<metgawzen> {
  @override
  Widget build(BuildContext context) {
    return soonWidget(tablee: tablee);
  }
}
