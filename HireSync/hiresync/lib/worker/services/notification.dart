import 'package:flutter/material.dart';

class Notification_worker extends StatefulWidget {
  const Notification_worker({super.key});

  @override
  State<Notification_worker> createState() => _Notification_workerState();
}

class _Notification_workerState extends State<Notification_worker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00c0c0c),
      body: Container(
        child: Center(
          child: Text("Notification_worker"),
        ),

      ),
    );
  }
}