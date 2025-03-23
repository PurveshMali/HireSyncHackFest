import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiresync/worker/workermodel/workermodel.dart';


Future<void> updateUserDetailsAndLocation({
  required String name,
  required String dateOfBirth,
  required String bloodGroup,
  required String gender,
  required double height,
  required double weight,
  double? latitude,
  double? longitude,
  String? city,
}) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    log("❌ No user logged in");
    return;
  }

  String uid = user.uid;

  // Fetch existing user data from Firestore
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("Worker").doc(uid).get();

  Map<String, dynamic> existingData =
      userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};

  // Create updated user model with existing or new data
  Workermodel updatedUser = Workermodel(
    name: name.isNotEmpty ? name : existingData["name"] ?? "",
    dateOfBirth:
        dateOfBirth.isNotEmpty
            ? dateOfBirth
            : existingData["dateOfBirth"] ?? "",
    bloodGroup:
        bloodGroup.isNotEmpty ? bloodGroup : existingData["bloodGroup"] ?? "",
    gender: gender.isNotEmpty ? gender : existingData["gender"] ?? "",
    height: height != 0.0 ? height : existingData["height"]?.toDouble() ?? 0.0,
    weight: weight != 0.0 ? weight : existingData["weight"]?.toDouble() ?? 0.0,
    city: city ?? existingData["city"] ?? "Unknown",
    latitude: latitude ?? existingData["latitude"]?.toDouble() ?? 0.0,
    longitude: longitude ?? existingData["longitude"]?.toDouble() ?? 0.0,
    locationUpdatedAt: Timestamp.now(),
  );

  // Store updated details in Firestore
  await FirebaseFirestore.instance
      .collection("Worker")
      .doc(uid)
      .set(updatedUser.toMap(), SetOptions(merge: true));

  log("✅ User details and location updated successfully!");
}