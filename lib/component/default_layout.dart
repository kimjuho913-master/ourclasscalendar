import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool? resizeToAvoidBottomInset;
  final bool showBackButton;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
    this.showBackButton = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder를 사용해 현재 레이아웃의 크기를 가져옵니다.
    return LayoutBuilder(
      builder: (context, constraints) {
        // 모바일과 데스크톱을 나누는 기준점입니다.
        const double mobileBreakpoint = 600.0;

        // 현재 화면의 가로 너비가 기준보다 큰 경우 (데스크톱/태블릿)
        if (constraints.maxWidth > mobileBreakpoint) {
          // 데스크톱용 레이아웃
          return Scaffold(
            backgroundColor: Colors.grey[850], // 바깥 배경색
            // ★ 데스크톱에서는 키보드가 올라와도 화면이 줄어들지 않도록 설정
            resizeToAvoidBottomInset: false,
            body: Center(
              // ★ 데스크톱에서는 화면 비율을 고정
              child: AspectRatio(
                aspectRatio: 9 / 19.5,
                // 앱의 실제 내용을 담는 내부 Scaffold
                child: Scaffold(
                  backgroundColor: backgroundColor ?? Colors.white,
                  appBar: renderAppBar(),
                  body: child,
                  bottomNavigationBar: bottomNavigationBar,
                  floatingActionButton: floatingActionButton,
                ),
              ),
            ),
          );
        }
        // 현재 화면의 가로 너비가 기준보다 작은 경우 (모바일)
        else {
          // 기존 모바일용 레이아웃
          return Scaffold(
            backgroundColor: backgroundColor ?? Colors.white,
            appBar: renderAppBar(),
            body: child,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButton: floatingActionButton,
            // ★ 모바일에서는 전달된 값을 사용하되, 값이 없으면 기본값(true)으로 설정
            resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
          );
        }
      },
    );
  }

  // AppBar를 만드는 부분은 기존과 동일합니다.
  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: showBackButton,
        title: Text(
          title!,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}