import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiresync/email/verifyEmail.dart';
import 'package:hiresync/employeer/employeer_details.dart';
import 'package:hiresync/employeer/homepage_employeer.dart';
import 'package:hiresync/employeer/signin_employeer.dart';
import 'package:hiresync/worker/location/worker_locationpermission.dart';
// import 'package:nexacare/attendant/attendant_details.dart';
// import 'package:nexacare/attendant/homepage_attendant.dart';
// import 'package:nexacare/attendant/signin_attendant.dart';
// import 'package:nexacare/email/verifyEmail.dart';
// import 'package:nexacare/user/location/user_locationpermission.dart';

class Wrapperemployeer extends StatefulWidget {
  @override
  _WrapperemployeerState createState() => _WrapperemployeerState();
}

class _WrapperemployeerState extends State<Wrapperemployeer> {
  @override
  void initState() {
    super.initState();
    _checkUserState();
  }

  Future<void> _checkUserState() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Prevents flickering

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _navigateTo(SigninEmployeer());
    } else if (!user.emailVerified) {
      _navigateTo(Verifyemail());
    } else {
      bool detailsExist = await _doesUserDetailsExist();
      if (detailsExist) {
        _navigateTo(const HomepageEmployeer()); // Ask to fill details
      } else {
        _navigateTo(const EmployeerDetails());
      }
    }

    bool locationGranted = await _isLocationPermissionGranted();
    if (!locationGranted) {
      _navigateTo(WorkerLocationpermission()); // Request location permission
      return;
    }

    // If everything is set, go to homepage
    _navigateTo(const HomepageEmployeer());
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checks if the attendant's details already exist in Firestore
  Future<bool> _doesUserDetailsExist() async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Employeer').doc(user.uid).get();

      if (!snapshot.exists) return false; // Document does not exist

      var data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) return false;

      bool hasPersonalDetails =
          data.containsKey("name") &&
          data.containsKey("dateOfBirth") &&
          data.containsKey("mobileNumber") &&
          data.containsKey("gender") &&
          data.containsKey("homeAddress") &&
          data.containsKey("workLocation") &&
          data.containsKey("degree") &&
          data["name"].toString().trim().isNotEmpty &&
          data["dateOfBirth"].toString().trim().isNotEmpty &&
          data["mobileNumber"].toString().trim().isNotEmpty &&
          data["gender"].toString().trim().isNotEmpty &&
          data["homeAddress"].toString().trim().isNotEmpty &&
          data["workLocation"].toString().trim().isNotEmpty &&
          data["degree"].toString().trim().isNotEmpty;

      return hasPersonalDetails; // Return true only if all details exist
    } catch (e) {
      print("❌ Error fetching user details: $e");
      return false;
    }
  }

  /// Mock function to check if location permission is granted
  Future<bool> _isLocationPermissionGranted() async {
    // This should be replaced with actual location permission logic
    return Future.value(true); // Assume permission is granted
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xffFFA500))),
    );
  }
}