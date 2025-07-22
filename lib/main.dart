import 'package:class_calendar/firebase_options.dart';
import 'package:class_calendar/screen/splash_screen.dart';
import 'package:class_calendar/services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // main 함수는 기존과 동일합니다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();

  final firestoreService = FirestoreService();
  final colors = await firestoreService.getCategoryColors();
  if (colors.isEmpty) {
    const defaultColors = [
      'D32F2F', 'E84033', 'fa7a35', 'fae500', '22A45D',
      '0080ff', '000080', 'a020f0', 'fccacb', 'fdbf0f',
      'fffca1', 'cafca6', 'a6fcce', 'a6f4fc', 'a6d8fc',
      'a6c0fc', 'a6affc', 'dda6fc', 'fca6ca',
    ];
    await firestoreService.addDefaultColors(defaultColors);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: Scaffold(
        // 앱 영역 밖의 배경색을 지정하여 깔끔하게 보입니다.
        backgroundColor: Colors.grey[850], // 어두운 회색 배경
        body: Center( // 앱을 화면 정중앙에 배치합니다.
          // [핵심] AspectRatio 위젯으로 자식의 비율을 9:20으로 강제합니다.
          child: AspectRatio(
            aspectRatio: 9 / 20, // 가로 9, 세로 20 비율로 설정
            // 실제 앱 콘텐츠가 들어갈 부분
            child: Container(
              // Container로 한번 감싸서 배경색이나 그림자 효과 등을 추가할 수 있습니다.
              color: Colors.white, // 앱의 기본 배경색
              child: const SplashScreen(), // 앱의 첫 화면을 여기에 넣습니다.
            ),
          ),
        ),
      ),
    );
  }
}