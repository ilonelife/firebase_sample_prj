import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  AddUserScreen({Key? key}) : super(key: key);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': '아무개씨', // John Doe
            'company': '원즈라이프', // Stokes and Sons
            'age': 52 // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: const Text('유저 추가'),
    );
  }
}
