// ignore_for_file: use_build_context_synchronously

import 'package:d_dialog/d_dialog.dart';
import 'package:flutter/material.dart';
import 'package:love_choice/modules/appbars.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../style/styles.dart';

final supabase = Supabase.instance.client;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  // final usernameController = TextEditingController();

  bool isLogin = true;

  Future authGoogle() async {
    try {
      // ignore: unused_local_variable
      final res = await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.turk.lovechoice://login-callback',
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Future auth() async {
    final email = emailController.text;
    final pass = passController.text;
    // final username = usernameController.text;

    if (isLogin) {
      if (email.isEmpty || pass.isEmpty) return;
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: pass,
      );
      if (res.user != null) {
        Navigator.of(context).pushReplacementNamed('/onlineChat');
      }
    } else {
      final res = await supabase.auth.signUp(
        email: email,
        password: pass,
        emailRedirectTo: 'com.turk.lovechoice://login-callback',
      );

      final user = res.user;

      if (user != null) {
        await supabase.from('profiles').insert({
          'id': user.id, // مهم جدًا
          'username': email,
          'avatar_url': null,
        }).maybeSingle();

        isLogin = true;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacementNamed('/onlineHome');
        // تحقق من نجاح تسجيل الدخول
        final user = supabase.auth.currentUser;
        if (user != null) {
          await supabase.from('profiles').upsert({
            'id': user.id,
            'username': user.email,
            'avatar_url': user.userMetadata!['avatar_url'],
          }, onConflict: 'id');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/main");
              },
            ),
            title: Text(isLogin ? 'Login' : 'Sign Up'),
            centerTitle: true,
            backgroundColor: TurkStyle().mainColor,
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // if (!isLogin)
                //   TextField(
                //     controller: usernameController,
                //     decoration: InputDecoration(labelText: "Username"),
                //   ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: auth,
                  child: Text(isLogin ? "Login" : "Sign Up"),
                ),
                SizedBox(
                  width: 205,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authGoogle,
                    style: ElevatedButton.styleFrom(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/googleIcon.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          isLogin ? "Login With Google" : "Sign Up With Google",
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(
                    isLogin ? "Create Account" : "Have Account? Login",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
