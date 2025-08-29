import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/views/basic_counting_view.dart';
import 'package:counting_app/presentation/widgets/glass_icon_button.dart';
import 'package:flutter/material.dart';

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
      height: 80,
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

                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      offset.dx,
                      offset.dy - 80, // 메뉴가 버튼 위에 나타나도록 오프셋 조정
                      offset.dx + size.width,
                      offset.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        child: Text(localizations.settings),
                        onTap: () {
                          // TODO: 설정 기능 구현
                        },
                      ),
                      PopupMenuItem(
                        child: Text(localizations.showHiddenLists),
                        onTap: () {
                          // TODO: 숨겨진 목록 표시 기능 구현
                        },
                      ),
                    ],
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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
