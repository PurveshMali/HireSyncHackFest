
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiresync/util/navbar.dart';
import 'package:hiresync/worker/employeeService/near_employee.dart';
import 'package:hiresync/worker/location/livelocation_page.dart';
 import 'package:hiresync/worker/services/notification.dart';
 // import 'package:nexacare/Chat_Service/Chat_Screens/chatBox.dart';
// import 'package:nexacare/services/chatBox/listOfattendantforchat.dart';
// import 'package:nexacare/user/attendantService/near_Attendant.dart';
// import 'package:nexacare/user/location/livelocation_page.dart';
// import 'package:nexacare/user/profile/user_profile.dart';
// import 'package:nexacare/utils/navbar.dart';

import 'dart:async';

import 'package:hiresync/worker/profile/worker_profile.dart';

class Homepageworker extends StatefulWidget {
  const Homepageworker({super.key});

  @override
  State<Homepageworker> createState() => _HomepageworkerState();
}

class _HomepageworkerState extends State<Homepageworker>
    with TickerProviderStateMixin {
  User? user;
  int _selectedIndex = 0;
  Color _fabColor = const Color(0xffFFA500);

  String _userName = "Worker";
  String _userLocation = "No Location Info";

  final List<Widget> _screens = [
    NearEmployee(),
    LivelocationPage(),
      Notification_worker(),
    WorkerProfile(),
  ];

  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  int countdown = 5;
  bool isPressed = false;
  Timer? countdownTimer;
  Color buttonColor = Color(0xffFFA500);

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      if (mounted) {
        setState(() {
          user = newUser;
        });
      }
    });

    _fetchUserData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _fetchUserData() {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('Worker')
          .doc(user!.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
            if (snapshot.exists) {
              setState(() {
                _userName = snapshot['name'] ?? 'Worker';
                _userLocation =
                    snapshot['locationDetail'] ?? 'No Location Info';
              });
            }
          });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabPressed() {
    setState(() {
      _fabColor = Colors.red;
      _selectedIndex = 0;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _fabColor = const Color(0xffFFA500);
        });
      }
    });
  }

  void startCountdown() {
    setState(() {
      isPressed = true;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() {
          countdown--;
          buttonColor = countdown % 2 == 0 ? Color(0xffFFA500) : Colors.red;
        });
      } else {
        timer.cancel();
        sendSOSAlert();
        resetButton();
      }
    });
  }

  void resetButton() {
    setState(() {
      countdown = 5;
      isPressed = false;
      buttonColor = Color(0xffFFA500);
    });
  }

  void sendSOSAlert() {
    print("SOS triggered");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0C0C0C),
      appBar:
          _selectedIndex == 0
              ? AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hi, $_userName",
                      style: const TextStyle(
                        fontFamily: 'Font1',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _userLocation,
                      style: const TextStyle(
                        fontFamily: 'Font1',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xff0C0C0C),
              )
              : null,
      body:
          _selectedIndex == 0
              ? Center(
                child: GestureDetector(
                  onLongPress: startCountdown,
                  onLongPressEnd: (details) {
                    countdownTimer?.cancel();
                    resetButton();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            width: 200 + (_borderAnimation.value * 20),
                            height: 200 + (_borderAnimation.value * 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red,
                                width: 5 + (_borderAnimation.value * 5),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isPressed ? 150 : 180,
                        height: isPressed ? 150 : 180,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffFFA500),
                              blurRadius: 20,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isPressed ? "$countdown" : "Emergency",
                            style: const TextStyle(
                              fontFamily: 'Font1',
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : _screens[_selectedIndex - 1],
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _fabColor.withOpacity(0.9),
              spreadRadius: 10,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _onFabPressed,
          backgroundColor: _fabColor,
          splashColor: Colors.amber.shade600,
          elevation: 10,
          heroTag: "Unique_sos_fab",
          child: const Icon(Icons.search, size: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
