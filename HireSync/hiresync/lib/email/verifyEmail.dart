import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiresync/Routes/app_routes.dart';
// import 'package:nexacare/Routes/app_routes.dart';

class Verifyemail extends StatefulWidget {
  const Verifyemail({super.key});

  @override
  State<Verifyemail> createState() => _VerifyemailState();
}

class _VerifyemailState extends State<Verifyemail> {
  @override
  void initState() {
    super.initState();
    // Ensure context is available before calling sendVerifyLink()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendVerifyLink();
    });
  }

  Future<void> sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xff0C0C0C),
            content: const Text(
              'Verification link has been sent to your email.',
              style: TextStyle(fontFamily: 'Font1', color: Colors.white),
            ),
            margin: const EdgeInsets.all(30),
          ),
        );
      } catch (e) {
        print("Error sending email verification: $e");
      }
    }
  }

  Future<void> reload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        Navigator.pushNamed(context, Approutes.wrapper);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email not verified yet. Please check your inbox.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0C0C0C),
      appBar: AppBar(
        backgroundColor: const Color(0xff0C0C0C),
        title: const Text(
          "Verification",
          style: TextStyle(
            fontFamily: 'Font1',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Open your email and click on the link provided to verify your email.\nThen reload this page.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Font1',
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XffFFA500),
        onPressed: reload,
        child: const Icon(Icons.restart_alt_outlined),
      ),
    );
  }
}