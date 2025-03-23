import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiresync/Routes/app_routes.dart';
import 'package:hiresync/main.dart';
import 'package:hiresync/worker/signin_worker.dart';
import 'package:hiresync/worker/homepageWorker.dart'; // Add worker home page

import '../util/elevatedbutton.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  Future<void> checkWorkerStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Check if the worker exists in Firestore
      DocumentSnapshot workerDoc = await FirebaseFirestore.instance
          .collection('workers')
          .doc(user.uid)
          .get();

      if (workerDoc.exists) {
        // Worker exists, navigate to WorkerHomePage
        Navigator.pushNamed(context, Approutes.homepage_worker);
      } else {
        // Worker doesn't exist in Firestore, navigate to Sign In
        Navigator.pushNamed(context, Approutes.signin_worker);
      }
    } else {
      // No user signed in, navigate to Sign In
      Navigator.pushNamed(context, Approutes.signin_worker);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.6),
            Text(
              "HireSync",
              style: TextStyle(
                fontFamily: 'Font1',
                color: Color(0xffFFFFFF),
                fontSize: 40,
              ),
            ),
            Text(
              "Stay Safe, Stay Connected!",
              style: TextStyle(
                fontFamily: 'Font1',
                color: Color(0xffFFFFFF),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 20),
            customElevatedButton(
              text: "Worker",
              textStyle: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 20,
                fontFamily: 'Font1',
              ),
              onPressed: () {
                Navigator.pushNamed(context, Approutes.signin_worker);
              },
              buttonSize: const Size(300, 55),
            ),
            SizedBox(height: 20),
            customElevatedButton(
              text: "Employeer",
              textStyle: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 20,
                fontFamily: 'Font1',
              ),
              onPressed: () {
                Navigator.pushNamed(context, Approutes.sign_employeer);
              },
              buttonSize: const Size(300, 55),
            ),
          ],
        ),
      ),
    );
  }
}
