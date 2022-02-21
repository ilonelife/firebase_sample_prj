import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sample/firebase_options.dart';
import 'package:firebase_sample/presentation/auth_gate/auth_gate.dart';
import 'package:firebase_sample/presentation/photo_update_delete/photo_update_delete_view_model.dart';
import 'package:firebase_sample/presentation/photo_upload/photo_upload_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // 화면이 그려지기 전에 어떤 기능을 미리 초기화 할 때 사용
  // 카메라, DB  기능 등등...
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: PhotoUploadViewModel(),
      ),
      ChangeNotifierProvider.value(
        value: PhotoUpdateDeleteViewModel(),
      )
    ],
    child: const MyApp(),
  ));

  // runApp(
  //   ChangeNotifierProvider.value(
  //     value: PhotoUploadViewModel(),
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}
