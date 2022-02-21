import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../add_user/add_user_screen.dart';
import '../photo_list/photo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 로그아웃 샘플
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('로그아웃'),
            ),
            // 사용 샘플
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserScreen()),
                );
              },
              child: const Text('유저 추가'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userSnapshot =
                    await users.doc('ylQz9OgdUiHzEFlHyGPB').get();
                final user = userSnapshot.data()! as Map<String, dynamic>;

                setState(() {
                  userName = user['full_name'];
                });
              },
              child: const Text('특정 유저 정보 가져오기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoListScreen(),
                  ),
                );
              },
              child: const Text('사진 업로드'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('실시간 유저 정보 가져오기'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (context, snapshot) {
                print('!!!!!!!!!!!!!!!');
                // 데이터 확인 처리...
                if (snapshot.hasData) {
                  // snapshot.data == null
                  return const CircularProgressIndicator();
                }
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['full_name']),
                      );
                    },
                  ).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
