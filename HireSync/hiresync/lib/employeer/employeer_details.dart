import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiresync/Routes/app_routes.dart';
import 'package:hiresync/util/datepicker.dart';
import 'package:hiresync/util/dropdown.dart';
import 'package:hiresync/util/elevatedbutton.dart';
import 'package:hiresync/util/textfield.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:intl/intl.dart';

class EmployeerDetails extends StatefulWidget {
  const EmployeerDetails({super.key,});

  @override
  State<EmployeerDetails> createState() => _EmployeerDetailsState();
}

class _EmployeerDetailsState extends State<EmployeerDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController genderContrller = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();
  final TextEditingController WorkLocationController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    genderContrller.dispose();
    homeAddressController.dispose();
    WorkLocationController.dispose();
    degreeController.dispose();
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
    //if (mobileController.text.trim().isEmpty) emptyFields.add("Blood Group");
    if (genderContrller.text.trim().isEmpty) emptyFields.add("Gender");
    if (homeAddressController.text.trim().isEmpty)
      emptyFields.add("Home Location");
    if (WorkLocationController.text.trim().isEmpty)
      emptyFields.add("Work Location");
    if (degreeController.text.trim().isEmpty) emptyFields.add("Degree");

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
          await FirebaseFirestore.instance.collection("Employeer").doc(uid).get();

      Map<String, dynamic> existingData =
          userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};

      // Merge new user details with existing Firestore data
      Map<String, dynamic> updatedData = {
        "name": nameController.text.trim(),
        "dateOfBirth": dobController.text.trim(),
        "mobile number": mobileController.text.trim(),
        "gender": genderContrller.text.trim(),
        "home Address": homeAddressController.text.trim(),
        "Work Location" : WorkLocationController.text.trim(),
        "degree" :degreeController.text.trim(), 

        // Preserve existing location details if available
        "city": existingData["city"] ?? "",
        "latitude": existingData["latitude"] ?? 0.0,
        "longitude": existingData["longitude"] ?? 0.0,
        "locationUpdatedAt": existingData["locationUpdatedAt"] ?? null,
      };

      // Save data to Firestore
      await FirebaseFirestore.instance
          .collection('Employeer')
          .doc(uid)
          .set(
            updatedData,
            SetOptions(merge: true),
          ); // ✅ Merging ensures location isn't erased

      AnimatedSnackBar.material(
        "Employeer details saved successfully!",
        type: AnimatedSnackBarType.success,
        duration: Duration(seconds: 2),
        mobilePositionSettings: const MobilePositionSettings(
          topOnAppearance: 100,
        ),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);

      // Navigate to location permission screen
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(context, Approutes.employeerlocationPermission);
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
                    "Employeer Details",
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
                    "Stay informed and connectedto support seamless care",
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
                Text(
  "Mobile Number",
  style: TextStyle(
    color: Colors.white,
    fontFamily: 'Font1',
    fontSize: 15,
  ),
),
SizedBox(height: screenHeight * 0.01),
TextField(
  controller: mobileController,
  keyboardType: TextInputType.phone,
  maxLength: 10, // Assuming a 10-digit mobile number
  style: TextStyle(fontFamily: 'Font1'),
  decoration: TextfieldUtil.inputDecoration(
    hintText: "Enter your mobile number",
  
  ),
),

                SizedBox(height: screenHeight * 0.02),
                Text(
  "Employeer Degree",
  style: TextStyle(
    color: Colors.white,
    fontFamily: 'Font1',
    fontSize: 15,
  ),
),
SizedBox(height: screenHeight * 0.01),
TextField(
  controller: degreeController, // Use a TextEditingController to store input
  keyboardType: TextInputType.text, // Standard text input for degrees
  style: TextStyle(fontFamily: 'Font1'),
  decoration: TextfieldUtil.inputDecoration(
    hintText: "Enter Employeer Degree",
    
  ),
),
SizedBox(height: screenHeight*0.02,),

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
               Text(
  "Attendant Home Address",
  style: TextStyle(
    color: Colors.white,
    fontFamily: 'Font1',
    fontSize: 15,
  ),
),
SizedBox(height: screenHeight * 0.01),
TextField(
  controller: homeAddressController, // Use a TextEditingController to store input
  keyboardType: TextInputType.streetAddress,
  maxLines: 3, // Allow multiple lines for address input
  style: TextStyle(fontFamily: 'Font1'),
  decoration: TextfieldUtil.inputDecoration(
    hintText: "Enter Employeer Home Address",
    
  ),
),

                SizedBox(height: screenHeight * 0.02),
               Text(
  "Attendant Work Location",
  style: TextStyle(
    color: Colors.white,
    fontFamily: 'Font1',
    fontSize: 15,
  ),
),
SizedBox(height: screenHeight * 0.01),
TextField(
  controller: WorkLocationController, // Use a TextEditingController to store input
  keyboardType: TextInputType.streetAddress,
  maxLines: 2, // Allow multiple lines for work location input
  style: TextStyle(fontFamily: 'Font1'),
  decoration: TextfieldUtil.inputDecoration(
    hintText: "Enter Employeer Work Location",
    
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
                      Approutes.employeerlocationPermission,
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
