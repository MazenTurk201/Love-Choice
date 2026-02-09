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
    // عرف المتغير هنا بوضوح
    final GoogleSignIn googleSignIn = GoogleSignIn(
       // الـ Client ID اللي جبناه من الـ Console
      serverClientId: '405627178641-4k50np2k04isaa6m4eir4hdjgb5ns364.apps.googleusercontent.com',
    );

    // سجل دخول
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    // هنا الـ Error بتاع الـ await: 
    // في النسخ الجديدة هي Future، لو لسه بيطلع Error شيل الـ await
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // تأكد إن الأسماء مكتوبة صح (Case-sensitive)
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    print("Done!");

  } catch (e) {
    print("Error: $e");
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
