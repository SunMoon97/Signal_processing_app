//Add_person.dart
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'main.dart';
import 'person.dart';


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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title:Align(alignment: Alignment.center,
          child: Text('ADD PERSON'),
    ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) => name = value,
              style: const TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20),

            ),

            const SizedBox(height: 25,
            width: 25,),

            TextFormField(

              decoration: const InputDecoration(labelText: 'Blood Group'),
              onChanged: (value) => bloodGroup = value,
              style: const TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20),
            ),

            const SizedBox(height: 25,
              width: 25,),


            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              onChanged: (value) => age = int.tryParse(value) ?? 0,
              style: const TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20),
            ),

            const SizedBox(height: 25,
              width: 25,),


            ElevatedButton(
              onPressed: () async {
                // Save the person to Isar
                final person = Person(bloodGroup, name, age);
                await widget.isar.writeTxn((isar) {
                  isar.persons.put(person);
                } as Future Function());

                // Navigate back or perform any desired action
                Navigator.pop(context);
              },
              child: const Text('Save'),

            ),



          ],
        ),
      ),
    );
  }
}
