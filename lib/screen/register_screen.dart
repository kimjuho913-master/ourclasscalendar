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
  // [추가] Form의 상태를 관리하기 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();
  String studentId = '';
  String password = '';
  bool isLoading = false;

  void onRegisterPressed() async {
    // [수정] Form의 유효성을 먼저 검사합니다.
    // validate()가 false를 반환하면 (validator에서 에러 메시지를 반환하면) 더 이상 진행하지 않습니다.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final bool isAllowed =
      await _firestoreService.isStudentAllowed(studentId.trim());

      if (!isAllowed) {
        throw FirebaseAuthException(code: 'student-not-allowed');
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '${studentId.trim()}@hs.go',
        password: password.trim(),
      );

      await FirebaseAuth.instance.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입에 성공했습니다! 로그인해주세요.')),
        );
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      String message = '회원가입에 실패했습니다.';
      if (e.code == 'student-not-allowed') {
        message = '허용되지 않은 사용자입니다. 관리자에게 문의하세요.';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 가입된 학번이름입니다.';
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
            // [추가] Form 위젯으로 감싸서 유효성 검사를 활성화합니다.
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
                    '학번이름과 사용할 비밀번호를 입력해주세요.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    hintText: '학번이름',
                    onChanged: (value) => studentId = value,
                    // [추가] 학번이름이 비어있는지 검사합니다.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '학번이름을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    hintText: '비밀번호',
                    onChanged: (value) => password = value,
                    obscureText: true,
                    // [핵심] 비밀번호 유효성 검사 로직
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }
                      if (value.length < 6) {
                        return '비밀번호는 6자 이상이어야 합니다.';
                      }
                      if (!RegExp(r'[abcdefghijklmnopqrstuvwxyz]').hasMatch(value)) {
                        return '비밀번호에 영문 소문자가 포함되어야 합니다.';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return '비밀번호에 숫자가 포함되어야 합니다.';
                      }
                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return '비밀번호에 특수문자가 포함되어야 합니다.';
                      }
                      return null; // 모든 조건을 만족하면 null을 반환 (에러 없음)
                    },
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: onRegisterPressed,
                      style: ElevatedButton.styleFrom(backgroundColor: goodColor),
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