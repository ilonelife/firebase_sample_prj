import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../home/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 유저 가입이 않된 경우
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration(),
            ],
          );
        }

        // 인증이 된 경우
        return const HomeScreen();
      },
    );
  }
}
