import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore CRUD Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createUser();
              },
              child: Text('Create'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _users.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  // Display the list of users
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                      return ListTile(
                        title:
                        Text('${data['name']} - ${data['age']} years old'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.update),
                              onPressed: () {
                                _showUpdateDialog(
                                    document.id, data['name'], data['age']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(document.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createUser() async {
    String name = _nameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;

    try {
      await _users.add({
        'name': name,
        'age': age,
      });
      print('User created successfully');
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  void _updateUser(String documentId, String newName, int newAge) async {
    try {
      await _users.doc(documentId).update({
        'name': newName,
        'age': newAge,
      });
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  void _deleteUser(String documentId) async {
    try {
      await _users.doc(documentId).delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  void _showUpdateDialog(String documentId, String currentName, int currentAge) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: TextEditingController(text: currentName),
                onChanged: (value) {
                  setState(() {
                    currentName = value;
                  });
                },
                decoration: InputDecoration(labelText: 'New Name'),
              ),
              TextFormField(
                controller: TextEditingController(text: currentAge.toString()),
                onChanged: (value) {
                  setState(() {
                    currentAge = int.tryParse(value) ?? 0;
                  });
                },
                decoration: InputDecoration(labelText: 'New Age'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUser(documentId, currentName, currentAge);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
