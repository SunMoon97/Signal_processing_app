import 'package:isar/isar.dart';
import 'package:flutter/material.dart';

part 'person.g.dart';

@Collection()
class Person {
  Id id = Isar.autoIncrement;
  late String bloodGroup;
  late String name;
  late int age;
  late double latitude;
  late double longitude;

  Person(
     {required String bloodGroup, required String name, required int age, required double latitude, required double longitude}
  );
}
