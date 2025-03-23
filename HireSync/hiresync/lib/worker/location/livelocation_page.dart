
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';

class LivelocationPage extends StatefulWidget {
  @override
  State<LivelocationPage> createState() => _LivelocationPageState();
}

class _LivelocationPageState extends State<LivelocationPage> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(20.5937, 78.9629); // Default: India

  /// Fetch user location stream from Firestore
  Stream<LatLng> _getUserLocationStream() {
    return FirebaseFirestore.instance.collection('User').snapshots().map((
      querySnapshot,
    ) {
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          double latitude = data['latitude'].toDouble();
          double longitude = data['longitude'].toDouble();

          // Debugging: Print live location updates
          print("Live Location Updated: Lat: $latitude, Lng: $longitude");

          return LatLng(latitude, longitude);
        }
      }
      return _currentLocation; // Return last known location
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
