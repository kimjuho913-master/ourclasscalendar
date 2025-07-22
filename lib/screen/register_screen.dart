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
  String studentId = '';
  String password = '';
  bool isLoading = false;

  void onRegisterPressed() async {
    if (studentId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('학번이름과 비밀번호를 모두 입력해주세요.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 1. 가입이 허용된 학생인지 확인
      final bool isAllowed =
      await _firestoreService.isStudentAllowed(studentId.trim());

      if (!isAllowed) {
        throw FirebaseAuthException(code: 'student-not-allowed');
      }

      // 2. 허용된 학생이면, 계정 생성 시도
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '${studentId.trim()}@hs.go',
        password: password.trim(),
      );

      // [수정됨] 계정 생성 후 즉시 로그아웃하여 자동 로그인을 방지합니다.
      await FirebaseAuth.instance.signOut();

      // 3. 성공 시, 로그인 화면으로 돌아가기
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text('회원가입에 성공했습니다! 로그인해주세요.'))),
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
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: '비밀번호 (6자 이상)',
                  onChanged: (value) => password = value,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: onRegisterPressed,
                    style: ElevatedButton.styleFrom(backgroundColor: goodColor),
                    child:
                    const Text('가입하기', style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}