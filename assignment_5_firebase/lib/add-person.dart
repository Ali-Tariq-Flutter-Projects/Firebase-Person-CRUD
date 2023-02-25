import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>['Male', 'Female'];

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({Key? key}) : super(key: key);

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();

  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Person');
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: nameController,
              maxLines: 1,
              decoration: const InputDecoration(
                  hintText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: genderController,
              maxLines: 1,
              decoration: const InputDecoration(
                  hintText: 'Gender', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: emailController,
              maxLines: 1,
              decoration: const InputDecoration(
                  hintText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: contactController,
              maxLines: 1,
              decoration: const InputDecoration(
                  hintText: 'Contact', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 400,
              child: ElevatedButton(
                  onPressed: () {
                    // loading:
                    // loading;
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    databaseRef.child(id).set({
                      'id': id,
                      'name': nameController.text.toString(),
                      'gender': genderController.text.toString(),
                      'email': emailController.text.toString(),
                      'contact': contactController.text.toString(),
                    }).then((value) {
                      print('Person Added');
                      loading = false;
                    }).onError((error, stackTrace) {
                      print('Person Adding Error');
                      loading = false;
                    });
                    nameController.clear();
                    genderController.clear();
                    contactController.clear();
                    emailController.clear();
                  },
                  child: const Text('Add')),
            ),
          ],
        ),
      ),
    );
  }
}
