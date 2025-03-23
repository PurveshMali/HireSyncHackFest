import 'package:flutter/material.dart';

class AddjobEmployeer extends StatefulWidget {
  const AddjobEmployeer({super.key});

  @override
  State<AddjobEmployeer> createState() => _AddjobEmployeerState();
}

class _AddjobEmployeerState extends State<AddjobEmployeer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Add job"),
        ),
      ),
    );
  }
}