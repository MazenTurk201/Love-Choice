// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class metgawzenPassword extends StatefulWidget {
  const metgawzenPassword({super.key});

  @override
  State<metgawzenPassword> createState() => _metgawzenPasswordState();
}

class _metgawzenPasswordState extends State<metgawzenPassword> {
  final TextEditingController controler = TextEditingController();
  final TextEditingController controler2 = TextEditingController();
  bool metgawzen_password_stat = false;
  int? metgawzen_password;

  Future<void> loadwarning() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      metgawzen_password_stat = pref.getBool("metgawzen_password") ?? false;
      metgawzen_password = pref.getInt("metgawzen_password_num") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadwarning();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          backgroundColor: Color.fromARGB(255, 55, 0, 255),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.black,

        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset("images/main.jpg", fit: BoxFit.cover),
            ),
            metgawzen_password_stat
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Text("الباسورد"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: TextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          onSubmitted: (value) async {
                            final pref = await SharedPreferences.getInstance();
                            if (int.parse(controler2.text) ==
                                pref.getInt("metgawzen_password_num")) {
                              Navigator.pushReplacementNamed(
                                context,
                                "/metgawzen",
                              );
                            } else {
                              controler2.text = "غلط";
                            }
                          },
                          cursorColor: Color.fromARGB(255, 55, 0, 255),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 55, 0, 255),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 55, 0, 255),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            hint: Text(
                              "Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                            label: Text(
                              "منورين",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: "TurkFont",
                              ),
                            ),
                          ),
                          cursorHeight: 30,
                          style: TextStyle(fontFamily: "TurkFont"),
                          textAlign: TextAlign.center,
                          controller: controler2,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Text(
                        "اكتب الباسورد اللي هتدخل بيه",
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: TextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          onSubmitted: (value) async {
                            if (controler.text.isNotEmpty) {
                              final pref =
                                  await SharedPreferences.getInstance();
                              await pref.setBool('metgawzen_password', true);
                              await pref.setInt(
                                'metgawzen_password_num',
                                int.parse(controler.text),
                              );
                              await pref.setBool('warning18', false);
                              Navigator.pushReplacementNamed(
                                context,
                                "/metgawzen",
                              );
                            }
                          },
                          cursorColor: Color.fromARGB(255, 55, 0, 255),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 55, 0, 255),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 55, 0, 255),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            hint: Text(
                              "Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                            label: Text(
                              "يستحسن يكون ذكرى بينكم",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: "TurkFont",
                              ),
                            ),
                          ),
                          cursorHeight: 30,
                          style: TextStyle(fontFamily: "TurkFont"),
                          textAlign: TextAlign.center,
                          controller: controler,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
