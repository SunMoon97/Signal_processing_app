import 'package:isar/isar.dart';
import 'package:flutter/material.dart';

part 'person.g.dart';

@Collection()
class Person {
  Id id = Isar.autoIncrement;
   String bloodGroup;
   String name;
   int age;
   double latitude;
   double longitude;

  Person({
    required this.bloodGroup,
    required this.name,
    required this.age,
    required this.latitude,
    required this.longitude,
  });

}
