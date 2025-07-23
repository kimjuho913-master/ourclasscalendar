import 'package:class_calendar/firebase_options.dart';
import 'package:class_calendar/screen/splash_screen.dart';
import 'package:class_calendar/services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

void main() async {
  // main 함수는 기존과 동일합니다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      // [수정] home에 SplashScreen을 직접 연결하여 비율 고정 기능을 완전히 제거합니다.
      home: const SplashScreen(),
    );
  }
}