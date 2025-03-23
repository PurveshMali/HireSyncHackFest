import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hiresync/Routes/app_routes.dart';
import 'package:logger/logger.dart';
// import 'package:nexacare/Routes/app_routes.dart';
 import 'package:hiresync/util/elevatedbutton.dart';
final log = Logger();

class WorkerLocationpermission extends StatefulWidget {
  const WorkerLocationpermission({super.key});

  @override
  State<WorkerLocationpermission> createState() => _WorkerLocationpermissionState();
}

class _WorkerLocationpermissionState extends State<WorkerLocationpermission> {
  String cityName = "Unknown";
  double latitude = 0.0;
  double longitude = 0.0;
  bool isUpdating = false;

  Future<void> updateUserLocation() async {
    setState(() {
      isUpdating = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log.e("❌ No user logged in");
      setState(() {
        isUpdating = false;
      });
      return;
    }

    try {
      // Check & Request Location Permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        log.w("⛔ Location permission permanently denied.");
        showErrorSnackBar("Location permission permanently denied.");
        setState(() {
          isUpdating = false;
        });
        return;
      }
      if (permission == LocationPermission.denied) {
        log.w("⚠️ Location permission denied.");
        showErrorSnackBar("Location permission denied.");
        setState(() {
          isUpdating = false;
        });
        return;
      }

      // Check if location services are enabled
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        log.w("⚠️ Location services are disabled.");
        showErrorSnackBar("Enable location services to continue.");
        setState(() {
          isUpdating = false;
        });
        return;
      }

      // Get Last Known Location First (for faster access)
      Position? position = await Geolocator.getLastKnownPosition();

      if (position == null) {
        // Fetching fresh location with a timeout
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10), // Timeout
        );
      }

      double lat = position.latitude;
      double lng = position.longitude;

      // Get Address from Coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.isNotEmpty ? placemarks.first : Placemark();

      String colony = place.subLocality ?? "Unknown Colony";
      String city = place.locality ?? "Unknown City";
      String country = place.country ?? "Unknown Country";

      log.i("📍 Location: $colony, $city, $country");

      String locationDetail =
          (colony.isNotEmpty && city.isNotEmpty)
              ? "$colony, $city"
              : city.isNotEmpty
              ? city
              : "Unknown Location";

      // Update Firestore Database
      String uid = user.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("User").doc(uid).get();
      Map<String, dynamic> existingData =
          userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};

      Map<String, dynamic> updatedData = {
        "locationDetail": locationDetail,
        "country": country,
        "latitude": lat,
        "longitude": lng,
        "locationUpdatedAt": Timestamp.now(),
        "name": existingData["name"] ?? "",
        "dateOfBirth": existingData["dateOfBirth"] ?? "",
        "bloodGroup": existingData["bloodGroup"] ?? "",
        "gender": existingData["gender"] ?? "",
        "height": existingData["height"] ?? 0.0,
        "weight": existingData["weight"] ?? 0.0,
      };

      await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .set(updatedData, SetOptions(merge: true));

      setState(() {
        cityName = locationDetail;
        latitude = lat;
        longitude = lng;
        isUpdating = false;
      });

      log.i("✅ Location updated successfully!");
      showSuccessSnackBar("Location updated successfully!");

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, Approutes.homepage_worker);
      });
    } catch (e) {
      log.e("❌ Failed to update location: $e");
      showErrorSnackBar("Failed to update location.");
      setState(() {
        isUpdating = false; // Ensure this runs even on errors
      });
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff0C0C0C),
      appBar: AppBar(
        title: const Text(
          "Location Permission",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
        backgroundColor: const Color(0xff0C0C0C),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              const Center(
                child: Icon(Icons.location_pin, size: 60, color: Colors.white),
              ),
              const Center(
                child: Text(
                  "Location Access",
                  style: TextStyle(
                    fontFamily: 'Font1',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.6),
              customElevatedButton(
                text: isUpdating ? "Updating..." : "Enable Location",
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Font1',
                  fontSize: 15,
                ),
                onPressed: isUpdating ? null : () => updateUserLocation(),
                buttonColor: const Color(0xffFFA500),
                buttonSize: const Size(310, 55),
                splashColor: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}