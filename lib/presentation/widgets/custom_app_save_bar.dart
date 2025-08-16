import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// 공통으로 사용될 AppBar 위젯입니다.
class CustomAppSaveBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSavePressed;
  final Color? saveButtonTextColor;

  // CustomAppBar 객체를 생성합니다.
  const CustomAppSaveBar({
    super.key,
    required this.title,
    this.onSavePressed,
    this.saveButtonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    // 현재 테마의 밝기를 확인합니다.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // 다크 모드 여부와 버튼 활성화 상태에 따라 텍스트 색상을 결정합니다.
    final textColor = saveButtonTextColor ??
        (onSavePressed != null
            ? (isDarkMode ? Colors.white : Colors.black)
            : Colors.grey);

    // 앱의 상단 바를 구성합니다.
    return AppBar(
      title: Text(title),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 21.0,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      actions: [
        if (onSavePressed != null)
          TextButton(
            onPressed: onSavePressed,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.saveBtn,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
