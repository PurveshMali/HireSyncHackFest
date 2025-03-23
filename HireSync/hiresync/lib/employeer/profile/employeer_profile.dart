
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:nexacare/screens/landingpage.dart';
import 'package:hiresync/sceens/landingpage.dart';

class EmployeerProfile extends StatefulWidget {
  const EmployeerProfile({Key? key}) : super(key: key);

  @override
  _AttedantProfileState createState() => _AttedantProfileState();
}

class _AttedantProfileState extends State<EmployeerProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Employeer Profile")),
        body: const Center(child: Text("No user logged in.")),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff0c0c0c),
      appBar: AppBar(
        backgroundColor: Color(0xff0c0c0c),
        title: const Text(
          "Employeer Profile",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              height: 50,
              width: 50,
              child: FloatingActionButton(
                splashColor: Colors.red,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Landingpage()),
                    (route) => false,  
                  );
                },
                backgroundColor: const Color.fromARGB(255, 255, 77, 0),

                child: const Icon(Icons.logout),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection("Employeer").doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User profile not found."));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(height: 100, width: 100),
                Card(
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
                        color: const Color.fromARGB(255, 236, 179, 74),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileField("Name", userData["name"]),
                          divider(),
                          profileField("Degree", userData["degree"]),
                          divider(),
                          profileField("Gender", userData["gender"]),
                          divider(),
                          profileField(
                            "Date of Birth",
                            userData["dateOfBirth"],
                          ),
                          divider(),
                          profileField(
                            "Mobile Number",
                            userData["mobile number"],
                          ),
                          divider(),
                          profileField(
                            "Home Address",
                            userData["home Address"],
                          ),
                          divider(),
                          profileField(
                            "Work Location",
                            userData["Work Location"],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper function to display a profile field
  Widget profileField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "$label: ${value ?? 'Not Available'}",
        style: const TextStyle(
          fontFamily: 'Font1',
          fontSize: 16,
          color: Color(0xff0C0C0C),
        ),
      ),
    );
  }

  /// Reusable Divider
  Widget divider() {
    return const Divider(color: Color(0xff0C0C0C), thickness: 1);
  }
}
