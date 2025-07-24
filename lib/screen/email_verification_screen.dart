import 'package:class_calendar/component/default_layout.dart';
import 'package:class_calendar/const/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  // [수정] 이제 User 객체 대신, 로그인에 필요한 이메일과 비밀번호를 직접 받습니다.
  final String email;
  final String password;

  const EmailVerificationScreen({
    required this.email,
    required this.password,
    super.key,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isLoading = false;

  Future<void> onVerificationButtonPressed() async {
    setState(() {
      isLoading = true;
    });

    User? userToDelete;

    try {
      // [핵심] 로그인 화면의 로직과 동일하게, 다시 로그인을 시도하여 최신 정보를 가져옵니다.
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // 로그인된 사용자의 최신 정보를 가져옵니다.
      final user = userCredential.user;
      userToDelete = user; // 실패 시 삭제를 위해 임시 저장

      if (user != null && user.emailVerified) {
        // [첫 번째 경우: 인증 성공]
        // 인증에 성공했으니, 바로 로그아웃시켜서 로그인 화면에서 다시 로그인하도록 유도합니다.
        await FirebaseAuth.instance.signOut();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Center(child: Text('인증 성공! 이제 로그인해주세요.')), backgroundColor: Colors.green),
        );

        if (mounted) {
          // 회원가입 -> 인증대기 화면으로 왔으므로, pop을 두 번 해서 로그인 화면까지 돌아갑니다.
          Navigator.of(context).pop(); // 인증 대기 화면 닫기
          Navigator.of(context).pop(); // 회원가입 화면 닫기
        }
      } else {
        // [두 번째 경우: 인증 실패]
        // 생성했던 계정을 삭제합니다.
        if (userToDelete != null) {
          await userToDelete.delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Center(child: Text('인증 실패. 다시 시도해 주세요.')),
              backgroundColor: Colors.red),
        );

        if (mounted) {
          Navigator.of(context).pop(); // 현재 화면을 닫고 회원가입 화면으로 돌아감
        }
      }
    } catch (e) {
      // 이메일 링크를 누르지 않아 로그인이 실패한 경우, 계정을 삭제합니다.
      if (userToDelete != null) {
        await userToDelete.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Center(child: Text('인증 실패. 다시 시도해 주세요.')),
            backgroundColor: Colors.red),
      );
      if(mounted){
        Navigator.of(context).pop();
      }
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
      title: '이메일 인증',
      showBackButton: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.email_outlined, size: 100, color: goodColor),
            const SizedBox(height: 32),
            const Text(
              '인증 이메일을 발송했습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.email}\n메일함을 확인하여 인증 링크를 클릭해주세요.\n\n링크를 클릭하신 후,\n아래 \'인증 완료\' 버튼을 눌러주세요.\n\n메일이 보이지 않는 경우,\n스팸함을 확인해 주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 48),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: onVerificationButtonPressed,
                style: ElevatedButton.styleFrom(backgroundColor: goodColor),
                child: const Text('인증 완료', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}