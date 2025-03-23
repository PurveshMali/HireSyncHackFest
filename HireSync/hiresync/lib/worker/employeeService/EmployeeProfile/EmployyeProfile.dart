
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Employyeprofile extends StatefulWidget {
  final String userId;
  const Employyeprofile({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewAttendantState createState() => _ViewAttendantState();
}

class _ViewAttendantState extends State<Employyeprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendant Profile",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection("Attendant")
                .doc(widget.userId)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffFFA500)),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User not found"));
          }

          var user = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Container(height: 100, width: 100),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Color(0xff0c0c0c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 179, 74),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: AttendantInfo(user: user),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AttendantInfo extends StatelessWidget {
  final Map<String, dynamic> user;
  const AttendantInfo({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        infoRow("Name", user["name"]),
        divider(),
        infoRow("Degree", user["degree"]),
        divider(),
        infoRow("Gender", user["gender"]),
        divider(),
        infoRow("Date of Birth", user["dateOfBirth"]),
        divider(),
        infoRow("Mobile Number", user["mobile number"]),
        divider(),
        infoRow("Home Address", user["home Address"]),
        divider(),
        infoRow("Work Location", user["Work Location"]),
      ],
    );
  }

  Widget infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Text(
        "$title: ${value ?? "Not Available"}",
        style: const TextStyle(
          fontFamily: 'Font1',
          fontSize: 16,
          color: Color(0xff0C0C0C),
        ),
      ),
    );
  }
}

Widget divider() {
  return Divider(color: Color(0xff0C0C0C), thickness: 1);
}
