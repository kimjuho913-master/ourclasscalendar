import 'package:class_calendar/component/custom_text_form_field.dart';
import 'package:class_calendar/component/default_layout.dart';
import 'package:class_calendar/const/colors.dart';
import 'package:class_calendar/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String userId = '';
  String password = '';
  bool isLoading = false;

  void onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final bool isAllowed =
      await _firestoreService.isUserAllowed(userId.trim());

      if (!isAllowed) {
        throw FirebaseAuthException(code: 'user-not-allowed');
      }

      // 1. 사용자 계정을 생성합니다.
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '23hs${userId.trim()}@cbhs.hs.kr',
        password: password.trim(),
      );

      // [핵심] 생성된 계정으로 인증 이메일을 보냅니다.
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
      }

      // 가입 후에는 자동 로그인을 막기 위해 로그아웃 처리합니다.
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        // [수정] 사용자에게 이메일을 확인하라는 안내 메시지를 보여줍니다.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원가입 완료! 학교 이메일을 확인하여 계정을 활성화해주세요.'),
            duration: Duration(seconds: 5), // 메시지를 더 오래 표시
          ),
        );
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      String message = '회원가입에 실패했습니다.';
      if (e.code == 'user-not-allowed') {
        message = '허용되지 않은 사용자입니다. 관리자에게 문의하세요.';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 가입된 학번입니다.';
      } else if (e.code == 'weak-password') {
        message = '비밀번호는 6자 이상이어야 합니다.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '회원가입',
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    '환영합니다!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '학번과 사용할 비밀번호를 입력해주세요.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    hintText: '학번',
                    onChanged: (value) => userId = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '학번을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    hintText: '비밀번호',
                    onChanged: (value) => password = value,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }
                      if (value.length < 6) {
                        return '비밀번호는 6자 이상이어야 합니다.';
                      }
                      if (!RegExp(r'[abcdefghijklmnopqrstuvwxyz]')
                          .hasMatch(value)) {
                        return '비밀번호에 영문 소문자가 포함되어야 합니다.';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return '비밀번호에 숫자가 포함되어야 합니다.';
                      }
                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return '비밀번호에 특수문자가 포함되어야 합니다.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: onRegisterPressed,
                      style:
                      ElevatedButton.styleFrom(backgroundColor: goodColor),
                      child: const Text('가입하기',
                          style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}