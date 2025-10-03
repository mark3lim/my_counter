import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/views/basic_counting_view.dart';
import 'package:counting_app/main/views/hidden_lists_view.dart';
import 'package:counting_app/main/views/settings_view.dart';
import 'package:counting_app/main/widgets/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class BottomNavBar extends StatelessWidget {
  final int currentPage;

  // 하단 네비게이션 바 위젯입니다.
  const BottomNavBar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    // 현재 테마의 밝기 모드를 확인합니다.
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      // 기본 동작 또는 에러 처리
      return const SizedBox.shrink();
    }
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 86.0 + MediaQuery.of(context).padding.bottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 햄버거 아이콘 버튼 (팝업 메뉴 기능 적용)
          GlassIconButton(
            icon: Icons.add_circle,
            iconColor: isDarkMode ? Colors.white : Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, BasicCountingView.routeName);
            },
          ),
          // 페이지를 나타내는 점
          Row(
            children: List.generate(2, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: currentPage == index ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
              );
            }),
          ),
          // 설정 아이콘 버튼 (리퀴드 글래스 효과 적용)
          Builder(
            builder: (context) {
              return GlassIconButton(
                icon: Icons.settings,
                iconColor: isDarkMode ? Colors.white : Colors.black,
                onPressed: () {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final Offset offset = renderBox.localToGlobal(Offset.zero);
                  final Size size = renderBox.size;

                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                    barrierColor: Colors.transparent,
                    transitionDuration: const Duration(milliseconds: 200),
                    transitionBuilder: (context, animation, secondaryAnimation, child) {
                      final tween = Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(0, -0.1),
                      );
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      );

                      return SlideTransition(
                        position: tween.animate(curvedAnimation),
                        child: FadeTransition(
                          opacity: curvedAnimation,
                          child: child,
                        ),
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Stack(
                        children: [
                          Positioned(
                            top: ((offset.dy - 32)
                                  .clamp(8.0, MediaQuery.of(context).size.height - 100 - 8.0))
                                  .toDouble(),
                            left: ((offset.dx + size.width - 170)
                                   .clamp(8.0, MediaQuery.of(context).size.width - 200 - 8.0))
                                   .toDouble(),
                            child: Material(
                              color: Colors.transparent,
                              child: GlassmorphicContainer(
                                width: 200,
                                height: 100,
                                borderRadius: 15,
                                blur: 20,
                                alignment: Alignment.center,
                                border: 0.4,
                                linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.surfaceContainer.withAlpha((255 * 0.4).round()),
                                    Theme.of(context).colorScheme.surfaceContainer.withAlpha((255 * 0.3).round()),
                                  ],
                                  stops: const [0.1, 1],
                                ),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.outline.withAlpha((255 * 0.5).round()),
                                    Theme.of(context).colorScheme.outline.withAlpha((255 * 0.2).round()),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, SettingsView.routeName);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
                                              const SizedBox(width: 10),
                                              Text(
                                                localizations.settings,
                                                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, HiddenListsView.routeName);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.visibility, color: isDarkMode ? Colors.white : Colors.black),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  localizations.showHiddenLists,
                                                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
