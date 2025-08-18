import "package:flutter/material.dart";
import '../modules/appbars.dart';

class donation extends StatelessWidget {
  const donation({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "/main");
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
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
            backgroundColor: Color.fromARGB(255, 55, 0, 255),
            elevation: 4,
            automaticallyImplyLeading: false,
          ),
          body: Column(children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
