import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiresync/employeer/employeer%20service/addjob_employeer.dart';
import 'package:hiresync/employeer/employeer%20service/feedback_employeer.dart';
import 'package:hiresync/employeer/employeer%20service/history_employeer.dart';
import 'package:hiresync/employeer/employeer_details.dart';
import 'package:hiresync/employeer/employeer_util/navbarAtt.dart';
import 'package:hiresync/employeer/profile/employeer_profile.dart';

class HomepageEmployeer extends StatefulWidget {
  const HomepageEmployeer({super.key});

  @override
  State<HomepageEmployeer> createState() => _HomepageEmployeerState();
}

class _HomepageEmployeerState extends State<HomepageEmployeer> {
  User? attendant;
  int _selectedIndex = 0;
  String _employeerName = "Employeer";
  String _employeerLocation = "No Location Info";
  List<Widget> _screens = []; // Initially empty

  @override
  void initState() {
    super.initState();
    attendant = FirebaseAuth.instance.currentUser;

    if (attendant != null) {
      _fetchUserData();
      _initializeScreens(); // Initialize screens after fetching attendant data
    }

    FirebaseAuth.instance.authStateChanges().listen((User? newAttendant) {
      if (mounted) {
        setState(() {
          attendant = newAttendant;
        });
        if (newAttendant != null) {
          _fetchUserData();
          _initializeScreens(); // Reinitialize screens when user state changes
        }
      }
    });
  }

  /// Initializes the screens with a valid `attendantId`
  void _initializeScreens() {
    setState(() {
      _screens = [
        AddjobEmployeer(),
        HistoryEmployeer(),
        FeedbackEmployeer(), // Ensure `attendantId` is valid
        EmployeerProfile(),
      ];
    });
  }

  /// Fetches the logged-in attendant's details from Firestore
  void _fetchUserData() {
    if (attendant != null) {
      FirebaseFirestore.instance
          .collection('Employeer')
          .doc(attendant!.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          if (mounted) {
            setState(() {
              _employeerName = snapshot['name'] ?? 'Employeer';
              _employeerLocation =
                  snapshot['locationDetail'] ?? 'No Location Info';
            });
          }
        }
      });
    }
  }

  /// Handles bottom navigation bar selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0c0c0c),
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: const Color(0xff0c0c0c),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hi, $_employeerName",
                    style: const TextStyle(
                      fontFamily: 'Font1',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _employeerLocation,
                    style: const TextStyle(
                      fontFamily: 'Font1',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: _screens.isNotEmpty
          ? _screens[_selectedIndex]
          : Center(
              child: CircularProgressIndicator(
                color: Color(0xffFFA500),
              ),
            ), // Show loader if screens are not initialized
      bottomNavigationBar: NavbarAtt(
        selectedIndex: _selectedIndex,
        onItemSelected: _onTabSelected,
      ),
    );
  }
}
