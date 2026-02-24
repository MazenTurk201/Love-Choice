import 'package:flutter/material.dart';

import '../style/styles.dart';

class AppBarRouter extends StatefulWidget implements PreferredSizeWidget {
  final bool? isLogin;

  const AppBarRouter({super.key, this.isLogin});

  @override
  State<AppBarRouter> createState() => _AppBarRouterState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _AppBarRouterState extends State<AppBarRouter> {
  @override
  Widget build(BuildContext context) {
    switch (ModalRoute.of(context)?.settings.name) {
      case '/main':
        return AppBar(
          title: Text(
            "Love Choice",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "TurkLogo",
              fontSize: 35,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "قائمة الخيارات",
            ),
          ),
          centerTitle: true,
          backgroundColor: TurkStyle().mainColor,
          iconTheme: IconThemeData(color: Colors.white),
        );
      case '/setting':
        return AppBar(
          title: Text(
            "Setting",
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
          automaticallyImplyLeading: false,
        );
      case '/profile':
        return AppBar(
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
        );
      case '/soon':
        return AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(
              "قريبًا",
              style: TextStyle(fontFamily: "TurkD", fontSize: 35, color: Colors.white),
            ),
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
        );
      case '/metgawzen_password':
        return AppBar(
            title: Text(
              "Password",
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
            automaticallyImplyLeading: false,
          );
      // case '/auth':
      //   return;
      default:
        return AppBar(
          title: const Text(
            'Love Choice',
            style: TextStyle(fontFamily: "TurkLogo", fontSize: 35),
          ),
          backgroundColor: TurkStyle().mainColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
          ),
        );
    }
  }
}
