
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiresync/email/verifyEmail.dart';
import 'package:hiresync/employeer/employeer_details.dart';
import 'package:hiresync/employeer/homepage_employeer.dart';
import 'package:hiresync/worker/signin_worker.dart';
// import 'package:nexacare/email/verifyEmail.dart';
// import 'package:nexacare/user/homepage_user.dart';
// import 'package:nexacare/user/signin_User.dart';
// import 'package:nexacare/user/user_healthdetails.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    _checkUserState();
  }

   Future<void> _checkUserState() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Small delay to prevent flickering

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _navigateTo(const SigninWorker());
    } else if (!user.emailVerified) {
      _navigateTo(const Verifyemail());
    } else {
      bool detailsFilled = await _isUserDetailsFilled(user.uid);
      if (detailsFilled) {
        _navigateTo(const HomepageEmployeer());
      } else {
        _navigateTo(const EmployeerDetails());
      }
    }
  }

  /// Function to check if user health details are filled
  Future<bool> _isUserDetailsFilled(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("Worker").doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        bool hasLocation =
            data.containsKey("latitude") &&
            data.containsKey("longitude") &&
            data["latitude"] != null &&
            data["longitude"] != null;

        bool hasHealthDetails =
            data.containsKey("bloodGroup") &&
            data.containsKey("height") &&
            data.containsKey("weight") &&
            data.containsKey("gender") &&
            data["bloodGroup"] != "" &&
            data["height"] != 0.0 &&
            data["weight"] != 0.0 &&
            data["gender"] != "";

        return hasLocation && hasHealthDetails;
      }
      return false;
    } catch (e) {
      print("❌ Error checking user details: $e");
      return false;
    }
  }

  /// Function to navigate to a new screen and clear previous stack
  void _navigateTo(Widget screen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        (route) => false, // Clears all previous routes
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen while checking authentication
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xffFFA500))),
    );
  }
}