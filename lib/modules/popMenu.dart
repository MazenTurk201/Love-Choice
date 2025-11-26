import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../style/styles.dart';

enum TurkPopMenuType { home, chat }

class TurkPopMenu extends StatelessWidget {
  final TurkPopMenuType popMenuType;
  final String? name;

  const TurkPopMenu({super.key, required this.popMenuType, this.name});

  @override
  Widget build(BuildContext context) {
    switch (popMenuType) {
      case TurkPopMenuType.home:
        return PopupMenuButton(
          icon: Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 30,
          ), // زرار الـ 3 نقط
          // ignore: deprecated_member_use
          color: TurkStyle().hoverColor.withOpacity(0.7), // خلفية المنيو
          onSelected: (value) {
            if (value == 'settings') {
              // Navigator.of(context).pushReplacementNamed(Routes().settings);
            } else if (value == 'report') {
              //
            } else if (value == 'delete') {
              // Navigator.of(context).pushReplacementNamed(Routes().home);
            } else if (value == 'logout') {
              Supabase.instance.client.auth.signOut();
              Navigator.pushReplacementNamed(context, "/main");
            }
          },
          itemBuilder: (context) => [
            TurkPopMenuItem("edit", "تعديل", Icons.edit),
            TurkPopMenuItem(
              "logout",
              "تسجيل خروج",
              Icons.logout_outlined,
              Colors.red,
            ),
          ],
        );
      case TurkPopMenuType.chat:
        return PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert_rounded,
            color: Colors.white,
            size: 30,
          ), // زرار الـ 3 نقط
          // ignore: deprecated_member_use
          color: TurkStyle().hoverColor.withOpacity(0.7), // خلفية المنيو
          onSelected: (value) {
            if (value == 'settings') {
              // Navigator.of(context).pushReplacementNamed(Routes().settings);
            } else if (value == 'report') {
              //
            } else if (value == 'delete') {
              // Navigator.of(context).pushReplacementNamed(Routes().home);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Settings", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'contacts',
              child: Row(
                children: [
                  Icon(Icons.pest_control, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Contacts", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'website',
              child: Row(
                children: [
                  Icon(Icons.insert_link_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Website", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        );
    }
  }
}

PopupMenuItem<String> TurkPopMenuItem(
  String value,
  String text,
  IconData icon, [
  Color? color,
]) {
  return PopupMenuItem<String>(
    value: value,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(text, style: TextStyle(color: color ?? Colors.white)),
        SizedBox(width: 8),
        Icon(
          icon,
          color: color ?? Colors.white, // لو null هياخد الأبيض
        ),
      ],
    ),
  );
}
