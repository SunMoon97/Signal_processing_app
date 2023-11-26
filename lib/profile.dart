import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'person.dart'; // Replace this with your Person class file

class ProfileScreen extends StatefulWidget {
  final Isar isar;

  const ProfileScreen({Key? key, required this.isar}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Person> persons;

  @override
  void initState() {
    super.initState();
    persons = [];
    _loadPersons();
  }

  Future<void> _loadPersons() async {
    final allPersonsNullable = await widget.isar.persons.where().findAll();
    final nonNullablePersons =
        allPersonsNullable?.where((person) => person != null).cast<Person>() ??
            [];
    setState(() {
      persons = nonNullablePersons.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: persons != null && persons.isNotEmpty
          ? ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return ListTile(
                  title: Text(person.name),
                  subtitle: Text('${person.bloodGroup}, Age: ${person.age}'),
                );
              },
            )
          : Center(
              child: Text('No data available'),
            ),
    );
  }
}
