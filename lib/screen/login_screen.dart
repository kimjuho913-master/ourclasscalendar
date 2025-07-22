import 'package:class_calendar/component/custom_text_form_field.dart';
import 'package:class_calendar/component/default_layout.dart';
import 'package:class_calendar/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../const/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // 현재 화면의 너비를 가져옵니다.
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 35.0), // 상단 여백
                const _Title(),
                const SizedBox(height: 8.0),
                const _SubTitle(),
                // [수정] 이미지 위젯
                // 화면 너비의 60%를 차지하도록 너비를 설정합니다.
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Image.asset(
                    'asset/img/logo.png',
                  ),
                ),

                const SizedBox(height: 16.0), // 이미지와 입력창 사이 여백

                CustomTextFormField(
                  hintText: '학번이름을 입력해주세요.',
                  onChanged: (String value) {
                    email = '$value@hs.go';
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // 로그인 로직은 그대로 유지
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
                      );
                      return;
                    }
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.trim(),
                        password: password.trim(),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message = '로그인에 실패했습니다.';
                      if (e.code == 'user-not-found' ||
                          e.code == 'wrong-password' ||
                          e.code == 'invalid-credential') {
                        message = '학번이름 또는 비밀번호가 잘못되었습니다.';
                      } else if (e.code == 'invalid-email') {
                        message = '유효하지 않은 학번이름 형식입니다.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goodColor,
                  ),
                  child: const Text('로그인', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// _Title과 _SubTitle 위젯은 반응형 폰트 크기를 유지합니다.
class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {

    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {

    return Text(
      '회원가입 후 로그인 해주세요!\n오늘도 성공적인 하루가 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: grColor,
      ),
    );
  }
}