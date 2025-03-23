import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiresync/sceens/landingpage.dart';
 import 'package:hiresync/worker/worker_service/worker_data_service.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});

  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    WorkerDataService userdataService = WorkerDataService();
    Map<String, dynamic>? data = await userdataService.getUserData();

    if (mounted) {
      setState(() {
        userData = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0C0C0C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Font1',
            fontSize: 20,
            color: Color(0xffffffff),
          ),
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
      backgroundColor: Color(0xff0C0C0C),

      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xffFFA500)),
              )
              : userData == null
              ? const Center(
                child: Text(
                  "No data available",
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Icon(Icons.person, color: Color(0xffffffff), size: 80),
                    Text(
                      "Health Details",
                      style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                    ),

                    Padding(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userInfo("Name", userData?["name"]),
                            Divider(),
                            userInfo("Blood Group", userData?["bloodGroup"]),
                            Divider(),
                            userInfo("Gender", userData?["gender"]),
                            Divider(),
                            userInfo("Date of Birth", userData?["dateOfBirth"]),
                            Divider(),
                            userInfo("Height", "${userData?["height"]} cm"),
                            Divider(),
                            userInfo("Weight", "${userData?["weight"]} kg"),
                            Divider(),
                            userInfo("Location", userData?["locationDetail"]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

Widget userInfo(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Text(
      "$label: ${value ?? 'N/A'}",
      style: TextStyle(
        fontFamily: 'Font1',
        fontSize: 16,
        color: Color(0xff0C0C0C),
      ),
    ),
  );
}

Widget divider() {
  return Divider(color: Color(0xff0C0C0C), thickness: 1);
}