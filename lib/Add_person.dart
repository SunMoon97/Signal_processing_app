import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:signal_processing/profile.dart';
import 'person.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPersonScreen extends StatefulWidget {
  final Isar isar;

  const AddPersonScreen({Key? key, required this.isar}) : super(key: key);

  @override
  AddPersonScreenState createState() => AddPersonScreenState();
}

class AddPersonScreenState extends State<AddPersonScreen> {
  String bloodGroup = '';
  String name = '';
  int age = 0;
  late Position _currentPosition;
  late Geolocator _geolocator;
  late StreamSubscription<Position> _positionStreamSubscription;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    _currentPosition = Position(
      latitude: 0.0,
      longitude: 0.0,
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      timestamp: DateTime.now(),
    );

    _checkLocationPermission();
    _startLocationTracking();
  }

  void _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (!permissionStatus.isGranted) {
      await Permission.location.request();
    }
  }

  void _startLocationTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream()
        .timeout(const Duration(seconds: 30))
        .listen((Position position) {
      if (!_isDisposed) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Align(
          alignment: Alignment.center,
          child: Text('ADD PERSON'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: theme.textTheme.headline6,
              ),
              onChanged: (value) => name = value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 25,
              width: 25,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Blood Group',
                labelStyle: theme.textTheme.headline6,
              ),
              onChanged: (value) => bloodGroup = value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 25,
              width: 25,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: theme.textTheme.headline6,
              ),
              onChanged: (value) => age = int.tryParse(value) ?? 0,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 25,
              width: 25,
            ),
            ElevatedButton(
              onPressed: () async {
                final person = Person(
                  bloodGroup: bloodGroup,
                  name: name,
                  age: age,
                  latitude: _currentPosition.latitude,
                  longitude: _currentPosition.longitude,
                );

                try {
                  if (_isDisposed) return;
                  final isar = await widget.isar;
                  isar.writeTxnSync(() => isar.persons.putSync(person));

                  print("Current Position: $_currentPosition");

                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(isar: widget.isar),
                    ),
                  );
                } catch (e) {
                  // Handle any potential exceptions or errors here
                  print("Error occurred: $e");
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
