import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';

class Livelocationemployeer extends StatefulWidget {
  @override
  State<Livelocationemployeer> createState() => _LivelocationemployeerState();
}

class _LivelocationemployeerState extends State<Livelocationemployeer> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(18.5204, 73.8567); // Default: Pune

  /// Fetch user location stream from Firestore
  Stream<LatLng> _getUserLocationStream() {
    return FirebaseFirestore.instance.collection('Employeer').snapshots().map((
      querySnapshot,
    ) {
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();

        print(
          "Firestore Raw Data: $data",
        ); // Debug: Check Firestore data format

        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          try {
            double latitude = (data['latitude'] as num).toDouble();
            double longitude = (data['longitude'] as num).toDouble();

            print("Extracted Location -> Lat: $latitude, Lng: $longitude");

            if (latitude != 0.0 && longitude != 0.0) {
              return LatLng(latitude, longitude);
            } else {
              print("Invalid Lat/Lng (0.0, 0.0), returning Pune default");
            }
          } catch (e) {
            print("Error parsing latitude/longitude: $e");
          }
        } else {
          print("Firestore document missing 'latitude' or 'longitude' keys.");
        }
      } else {
        print("No documents found in 'Employeer' collection.");
      }

      return _currentLocation; // Return Pune default if no valid data
    });
  }

  /// Update map position safely
  void _updateMapPosition(LatLng newLocation) {
    if (_currentLocation.latitude != newLocation.latitude ||
        _currentLocation.longitude != newLocation.longitude) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentLocation = newLocation;
          });
          _mapController.move(newLocation, 15.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location Map")),
      body: StreamBuilder<LatLng>(
        stream: _getUserLocationStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _updateMapPosition(snapshot.data!);
          } else if (snapshot.hasError) {
            print("Error fetching location: ${snapshot.error}");
          }

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_on,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.move(_currentLocation, 15.0);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}