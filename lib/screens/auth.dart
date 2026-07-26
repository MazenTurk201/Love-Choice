// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:love_choice/modules/authGate.dart';
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
      // final GoogleSignIn googleSignIn = GoogleSignIn(
      //   serverClientId:
      //       '405627178641-4k50np2k04isaa6m4eir4hdjgb5ns364.apps.googleusercontent.com',
      // );
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId:
            "405627178641-4k50np2k04isaa6m4eir4hdjgb5ns364.apps.googleusercontent.com",
      );

      // سجل دخول
      // final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final googleUser = await googleSignIn.authenticate();

      if (googleUser == null) return;

      // 🔥 رجعنا الـ await هنا عشان يقرأ الـ accessToken صح
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("Done!");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // 🔹 Email Auth
  Future authEmail() async {
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (email.isEmpty || pass.isEmpty) return;

    try {
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
    } catch (e) {
      debugPrint("Auth Email Error: $e");
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
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TurkStyle().mainColor,
          title: Text(
            isLogin ? "Login" : "Sign Up",
            style: const TextStyle(fontFamily: "TurkLogo", fontSize: 35),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                "images/onlineBackground.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: TurkStyle().mainColor, width: 2),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          TextField(
                            controller: passController,
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            onSubmitted: (_) => authEmail(),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: authEmail,
                            child: Text(isLogin ? "Login" : "Sign Up"),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            'or',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 10),

                          ElevatedButton.icon(
                            onPressed: authGoogle,
                            icon: Image.asset(
                              "images/googleIcon.png",
                              width: 24,
                            ),
                            label: Text(
                              isLogin
                                  ? "Login With Google"
                                  : "Sign Up With Google",
                            ),
                          ),

                          const Expanded(child: SizedBox()),

                          TextButton(
                            onPressed: () => setState(() => isLogin = !isLogin),
                            child: Text(
                              isLogin
                                  ? "Create Account?"
                                  : "Have Account? Login",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
