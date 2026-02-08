// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../style/styles.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  bool isLogin = true;

  // 🔹 Google Auth
  Future<void> authGoogle() async {
    try {
      // 1. استخدمنا authenticate() زي ما شفنا في الصورة
      final googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser == null) return;

      // 2. شيلنا الـ await لأنها مبقتش Future في النسخة دي
      final googleAuth = googleUser.authentication;

      // 3. بنعمل الـ Credential (لو accessToken لسه معترض، اتأكد إنك عامل Import لـ firebase_auth)
      // ملاحظة: لو بتجرب ويب، الـ accessToken ساعات مش بيكون متاح، فبنعتمد على idToken
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCred = await auth.signInWithCredential(credential);
      final user = userCred.user;

      if (user != null) {
        await createProfileIfNotExists(user);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, "/onlineHome");
      }
    } catch (e) {
      print("حصلت مشكلة يا ترك: $e");
    }
  }

  // 🔹 Email Auth
  Future authEmail() async {
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (email.isEmpty || pass.isEmpty) return;

    if (isLogin) {
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await createProfileIfNotExists(cred.user!);
      Navigator.pushReplacementNamed(context, "/onlineChat");
    } else {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await createProfileIfNotExists(cred.user!);

      setState(() => isLogin = true);
    }
  }

  // 🔹 Create Profile
  Future createProfileIfNotExists(User user) async {
    final ref = db.collection("profiles").doc(user.uid);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        "username": user.email,
        "avatar_url": user.photoURL,
        "created_at": FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TurkStyle().mainColor,
          title: Text(isLogin ? "Login" : "Sign Up"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: authEmail,
                child: Text(isLogin ? "Login" : "Sign Up"),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: authGoogle,
                icon: Image.asset("images/googleIcon.png", width: 24),
                label: Text(
                  isLogin ? "Login With Google" : "Sign Up With Google",
                ),
              ),

              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? "Create Account" : "Have Account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
