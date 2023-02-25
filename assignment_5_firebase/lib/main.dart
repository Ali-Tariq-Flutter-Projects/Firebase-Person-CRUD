import 'package:assignment_5_firebase/add-person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Person');
  final editnameController = TextEditingController();
  final editgenderController = TextEditingController();
  final editemailController = TextEditingController();
  final editcontactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPersonScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                padding: EdgeInsets.all(10),
                controller: ScrollController(),
                physics: BouncingScrollPhysics(),
                defaultChild: const Text('Loading'),
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  return Card(
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: 1),
                      title: Text(snapshot.child('name').value.toString()),
                      subtitle: Text(snapshot.child('gender').value.toString() +
                          '\n' +
                          snapshot.child('email').value.toString() +
                          '\n' +
                          snapshot.child('contact').value.toString()),
                      isThreeLine: true,
                      enabled: true,
                      trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(
                                            snapshot
                                                .child('name')
                                                .value
                                                .toString(),
                                            snapshot
                                                .child('id')
                                                .value
                                                .toString(),
                                            snapshot
                                                .child('gender')
                                                .value
                                                .toString(),
                                            snapshot
                                                .child('contact')
                                                .value
                                                .toString(),
                                            snapshot
                                                .child('email')
                                                .value
                                                .toString());
                                      },
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref
                                            .child(snapshot
                                                .child('id')
                                                .value
                                                .toString())
                                            .remove();
                                      },
                                    ))
                              ]),
                      contentPadding: EdgeInsets.all(10),
                      autofocus: true,
                      shape: OutlineInputBorder(),
                      tileColor: Colors.white,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String name, String id, String gender,
      String contact, String email) async {
    editnameController.text = name;
    editgenderController.text = gender;
    editemailController.text = email;
    editcontactController.text = contact;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
                height: 350,
                child: Column(
                  children: [
                    TextField(
                      controller: editnameController,
                      decoration: InputDecoration(
                          hintText: 'Edit Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: editgenderController,
                      decoration: InputDecoration(
                          hintText: 'Edit Gender',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: editemailController,
                      decoration: InputDecoration(
                          hintText: 'Edit Email', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: editcontactController,
                      decoration: InputDecoration(
                          hintText: 'Edit Contact',
                          border: OutlineInputBorder()),
                    ),
                  ],
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'name': editnameController.text.toString(),
                      'gender': editgenderController.text.toString(),
                      'email': editemailController.text.toString(),
                      'contact': editcontactController.text.toString()
                    }).then((value) {
                      print('Updated successfully');
                    }).onError((error, stackTrace) {
                      print('error updating');
                    });
                  },
                  child: Text('Update'))
            ],
          );
        });
  }
}
