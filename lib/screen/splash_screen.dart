import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:class_calendar/screen/home_screen.dart';
import 'package:class_calendar/screen/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 연결 상태를 기다리는 동안 로딩 화면을 보여줍니다.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 로그인된 사용자가 있는지 확인합니다.
        final isLoggedIn = snapshot.hasData;

        // 로그인 상태에 따라 다른 화면을 보여줍니다.
        if (isLoggedIn) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}