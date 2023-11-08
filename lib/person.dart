//person.dart
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';


part 'person.g.dart';
@Collection()
class Person {
  Id id=Isar.autoIncrement;
  late String bloodGroup;
  late String name;
  late int age;

  Person(this.bloodGroup, this.name, this.age);
}