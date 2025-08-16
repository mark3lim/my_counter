import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/views/basic_counting_view.dart';
import 'package:counting_app/presentation/widgets/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class BottomNavBar extends StatelessWidget {
  // 하단 네비게이션 바 위젯입니다.
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 테마의 밝기 모드를 확인합니다.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = Theme.of(context).iconTheme.color;
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      // 기본 동작 또는 에러 처리
      return const SizedBox.shrink();
    }

    // Glassmorphic 위젯을 사용하여 liquid glass 효과를 적용합니다.
    return GlassmorphicContainer(
      width: double.infinity,
      height: 80,
      borderRadius: 20,
      blur: 10,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDarkMode ? const Color(0x19FFFFFF) : const Color(0x33FFFFFF),
          isDarkMode ? const Color(0x0CFFFFFF) : const Color(0x19FFFFFF),
        ],
      ),
      borderGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x80FFFFFF),
          Color(0x80FFFFFF),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 햄버거 아이콘 버튼 (팝업 메뉴 기능 적용)
          Builder(
            builder: (buttonContext) {
              return GlassIconButton(
                icon: Icons.add_circle,
                iconColor: iconColor,
                onPressed: () {
                  Navigator.pushNamed(context, BasicCountingView.routeName);
                },
              );
            }
          ),
          // 페이지를 나타내는 점
          const Row(
            children: [
              Icon(Icons.circle, size: 8),
              SizedBox(width: 8),
              Icon(Icons.circle, size: 8, color: Colors.grey),
              SizedBox(width: 8),
              Icon(Icons.circle, size: 8, color: Colors.grey),
            ],
          ),
          // 설정 아이콘 버튼 (리퀴드 글래스 효과 적용)
          GlassIconButton(
            icon: Icons.settings,
            iconColor: iconColor,
            onPressed: () {
              // TODO: 설정 페이지로 이동하는 기능 구현
            },
          ),
        ],
      ),
    );
  }
}
