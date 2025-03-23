import 'package:cloud_firestore/cloud_firestore.dart';

class Workermodel {
  String name;
  String dateOfBirth;
  String bloodGroup;
  String gender;
  double height;
  double weight;
  String city;
  double latitude;
  double longitude;
  Timestamp? locationUpdatedAt; // Firestore timestamp

  Workermodel({
    required this.name,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.gender,
    required this.height,
    required this.weight,
    this.city = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.locationUpdatedAt,
  });

  // Convert Workermodel to Firestore format (Map)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'bloodGroup': bloodGroup,
      'gender': gender,
      'height': height,
      'weight': weight,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'locationUpdatedAt': locationUpdatedAt,
    };
  }

  // Convert Firestore document to Workermodel
  factory Workermodel.fromMap(Map<String, dynamic> map) {
    return Workermodel(
      name: map['name'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      gender: map['gender'] ?? '',
      height: (map['height'] ?? 0.0).toDouble(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      city: map['city'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      locationUpdatedAt: map['locationUpdatedAt'],
    );
  }
}