import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiresync/Routes/app_routes.dart';
import 'package:hiresync/util/datepicker.dart';
import 'package:hiresync/util/dropdown.dart';
import 'package:hiresync/util/elevatedbutton.dart';
import 'package:hiresync/util/picker.dart';
import 'package:hiresync/util/textfield.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:intl/intl.dart';

class WorkerDetails extends StatefulWidget {
  const WorkerDetails({super.key});

  @override
  State<WorkerDetails> createState() => _WorkerDetailsState();
}

class _WorkerDetailsState extends State<WorkerDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController bloodContrller = TextEditingController();
  final TextEditingController genderContrller = TextEditingController();
  final TextEditingController heightControler = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String selectedWeight = "";
  String selectedHeight = "";
  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    bloodContrller.dispose();
    genderContrller.dispose();
    heightControler.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> addUserDetails(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log("❌ No user logged in");
      return;
    }

    String uid = user.uid;

    // Check for empty fields
    List<String> emptyFields = [];
    if (nameController.text.trim().isEmpty) emptyFields.add("Name");
    if (dobController.text.trim().isEmpty) emptyFields.add("Date of Birth");
    if (bloodContrller.text.trim().isEmpty) emptyFields.add("Blood Group");
    if (genderContrller.text.trim().isEmpty) emptyFields.add("Gender");
    if (selectedHeight.isEmpty) emptyFields.add("Height");
    if (selectedWeight.isEmpty) emptyFields.add("Weight");

    if (emptyFields.isNotEmpty) {
      AnimatedSnackBar.material(
        "Please fill in: ${emptyFields.join(', ')}",
        type: AnimatedSnackBarType.warning,
        duration: Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
      return;
    }

    try {
      // Fetch existing user data
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("Worker").doc(uid).get();

      Map<String, dynamic> existingData =
          userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};

      // Merge new user details with existing Firestore data
      Map<String, dynamic> updatedData = {
        "name": nameController.text.trim(),
        "dateOfBirth": dobController.text.trim(),
        "bloodGroup": bloodContrller.text.trim(),
        "gender": genderContrller.text.trim(),
        "height": double.tryParse(selectedHeight.replaceAll(" cm", "")) ?? 0.0,
        "weight": double.tryParse(selectedWeight.replaceAll(" kg", "")) ?? 0.0,

        // Preserve existing location details if available
        "city": existingData["city"] ?? "",
        "latitude": existingData["latitude"] ?? 0.0,
        "longitude": existingData["longitude"] ?? 0.0,
        "locationUpdatedAt": existingData["locationUpdatedAt"] ?? null,
      };

      // Save data to Firestore
      await FirebaseFirestore.instance
          .collection('Worker')
          .doc(uid)
          .set(
            updatedData,
            SetOptions(merge: true),
          ); // ✅ Merging ensures location isn't erased

      AnimatedSnackBar.material(
        "Health details saved successfully!",
        type: AnimatedSnackBarType.success,
        duration: Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);

      // Navigate to location permission screen
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(context, Approutes.workerlocationpermission);
      });
    } catch (e) {
      AnimatedSnackBar.material(
        "Failed to save details: $e",
        type: AnimatedSnackBarType.error,
        duration: Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0C0C0C),
        title: Text(
          "HireSync",
          style: TextStyle(
            fontFamily: 'Font1',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Color(0xff0C0C0C),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(Icons.person, color: Color(0xffFFFFFF), size: 60),
                ),
                SizedBox(height: screenHeight * 0.015),
                Center(
                  child: Text(
                    "Set up Health Details",
                    style: TextStyle(
                      fontFamily: 'Font1',
                      color: Color(0xffFFFFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Center(
                  child: Text(
                    "Track. Monitor. Thrive.",
                    style: TextStyle(
                      fontFamily: 'Font1',
                      color: Color(0xffFFFFFF),
                      fontSize: 10,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: 'Font1'),
                  decoration: TextfieldUtil.inputDecoration(
                    hintText: "Enter your Name",
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Date of Birth",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  readOnly: true,
                  controller: dobController,
                  // keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: 'Font1'),
                  decoration: TextfieldUtil.inputDecoration(
                    hintText: "Enter your Date of Birth",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String? selectedDate = await Datepicker.selectDate(
                          context,
                        );
                        if (selectedDate != null) {
                          setState(() {
                            dobController.text = selectedDate;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: Color(0xff969292),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Blood Group",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  readOnly: true,
                  controller: bloodContrller,
                  // keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: 'Font1'),
                  decoration: TextfieldUtil.inputDecoration(
                    hintText: "Select your blood Group",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String? selectedValue = await showDropdownDialog(
                          context,
                          "Select Blood group",
                          ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
                        );
                        if (selectedValue != null && mounted) {
                          setState(() {
                            bloodContrller.text = selectedValue;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xff969292),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Gender",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  readOnly: true,
                  controller: genderContrller,
                  //keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: 'Font1'),
                  decoration: TextfieldUtil.inputDecoration(
                    hintText: "Select your Gender ",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String? selectedValue = await showDropdownDialog(
                          context,
                          "Select Gender",
                          ["Male", "Female", "Other"],
                        );
                        if (selectedValue != null && mounted) {
                          setState(() {
                            genderContrller.text = selectedValue;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xff969292),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Height",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  controller: TextEditingController(text: selectedHeight),
                  readOnly: true,
                  style: TextStyle(fontFamily: 'Font1'),
                  onTap: () {
                    CustomPicker.showPicker(
                      context,
                      title: "Select Height",
                      minValue: 100,
                      maxValue: 200,
                      unit: "cm",
                      onSelected: (height) {
                        setState(() {
                          selectedHeight = height;
                        });
                      },
                    );
                  },
                  decoration: TextfieldUtil.inputDecoration(
                    hintText: "Select your Height",
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xff969292),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Weight",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  controller: TextEditingController(text: selectedWeight),
                  readOnly: true,
                  style: TextStyle(fontFamily: 'Font1'),
                  onTap: () {
                    CustomPicker.showPicker(
                      context,
                      title: "Select Weight",
                      minValue: 30,
                      maxValue: 150,
                      unit: "kg",
                      onSelected: (weight) {
                        setState(() {
                          selectedWeight = weight;
                        });
                      },
                    );
                  },
                  decoration: TextfieldUtil.inputDecoration(
                    hintText: "Select your Weight",
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xff969292),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                customElevatedButton(
                  buttonSize: Size(310, 55),
                  buttonColor: Color(0xffFFA500),
                  text: "Next",
                  textStyle: TextStyle(
                    color: Color(0xff000000),
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                  onPressed: () {
                    addUserDetails(context);
                    Navigator.pushNamed(
                      context,
                      Approutes.workerlocationpermission,
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}