import 'package:flutter/material.dart';

class FeedbackEmployeer extends StatefulWidget {
  const FeedbackEmployeer({super.key});

  @override
  State<FeedbackEmployeer> createState() => _FeedbackEmployeerState();
}

class _FeedbackEmployeerState extends State<FeedbackEmployeer> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xff0c0c0c),
      body: Container(
        child: Text("Feedback"),
      ),
    );
  }
}