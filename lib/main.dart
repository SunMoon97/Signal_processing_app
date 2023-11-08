import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signal_processing/person.dart';
import 'Add_person.dart';

void main() {
  runApp(IsarServiceApp());
}

class IsarServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IsarService(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IsarService extends StatelessWidget {
  late Future<Isar?> db;

  IsarService() {
    db = openDB();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Isar?>(
      future: db,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final isar = snapshot.data;
          if (isar != null) {
            return MaterialApp(
              home: AddPersonScreen(isar: isar),
            );
          } else {
            // Handle the case where Isar initialization failed
            return MaterialApp(home: Container());
          }
        }
        // Handle the case while Isar is being initialized
        return MaterialApp(home: CircularProgressIndicator());
      },
    );
  }

  Future<Isar?> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.open(
        [PersonSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Isar.getInstance();
  }
}
