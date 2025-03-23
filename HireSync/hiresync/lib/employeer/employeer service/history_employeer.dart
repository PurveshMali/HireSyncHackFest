import 'package:flutter/material.dart';

class HistoryEmployeer extends StatefulWidget {
  const HistoryEmployeer({super.key});

  @override
  State<HistoryEmployeer> createState() => _HistoryEmployeerState();
}

class _HistoryEmployeerState extends State<HistoryEmployeer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("History of Employeer"),
      ),
    );
  }
}