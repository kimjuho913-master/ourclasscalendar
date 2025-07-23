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
  String userId = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 35.0),
                const _Title(),
                const SizedBox(height: 8.0),
                const _SubTitle(),
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: Image.asset(
                    'asset/img/logo.png',
                  ),
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '학번을 입력해주세요.',
                  onChanged: (String value) {
                    userId = value;
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
                    if (userId.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('학번과 비밀번호를 모두 입력해주세요.')),
                      );
                      return;
                    }
                    try {
                      // 1. 이메일 형식으로 로그인 시도
                      final userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: '23hs${userId.trim()}@cbhs.hs.kr',
                        password: password.trim(),
                      );

                      // [핵심] 로그인 성공 후, 이메일 인증이 완료되었는지 확인
                      if (userCredential.user != null &&
                          !userCredential.user!.emailVerified) {

                        // 인증이 안됐으면 바로 로그아웃 시키고 에러를 발생시켜 catch 블록으로 보냄
                        await FirebaseAuth.instance.signOut();
                        throw FirebaseAuthException(code: 'email-not-verified');
                      }

                    } on FirebaseAuthException catch (e) {
                      String message = '로그인에 실패했습니다.';
                      if (e.code == 'user-not-found' ||
                          e.code == 'wrong-password' ||
                          e.code == 'invalid-credential') {
                        message = '학번 또는 비밀번호가 잘못되었습니다.';
                      } else if (e.code == 'invalid-email') {
                        message = '유효하지 않은 학번 형식입니다.';
                      } else if (e.code == 'email-not-verified') {
                        // [핵심] 이메일 미인증 에러 처리
                        message = '이메일 인증이 필요합니다. 학교 메일함을 확인해주세요.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goodColor,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('로그인', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
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
    return const Text(
      '회원가입 후 로그인 해주세요!\n오늘도 성공적인 하루가 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: grColor,
      ),
    );
  }
}