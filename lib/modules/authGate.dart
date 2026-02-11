import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/onlineHome.dart';
import '../screens/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ⏳ Firebase لسه بيحمّل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )),
          );
        }

        // ✅ Logged in
        if (snapshot.hasData) {
          return const OnlineHomePage(); // أو OnlineChat
        }

        // ❌ Not logged in
        return const AuthPage();
      },
    );
  }
}
