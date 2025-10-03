import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

/// 공통으로 사용할 설정 플로팅 액션 버튼입니다.
class SettingsButton extends StatelessWidget {
  /// 버튼을 눌렀을 때 실행될 콜백 함수입니다.
  final VoidCallback onPressed;

  const SettingsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // iOS의 프로스티드 글래스(Frosted Glass) 효과를 내기 위해 GlassmorphicContainer를 사용합니다.
    // InkWell로 감싸서 탭 효과(ripple)와 콜백을 처리합니다.
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: GlassmorphicContainer(
        width: 56,
        height: 56,
        borderRadius: 28,
        blur: 15, // 블러 강도
        alignment: Alignment.center,
        border: 0.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainer.withAlpha((255 * 0.3).round()),
            Theme.of(context).colorScheme.surfaceContainer.withAlpha((255 * 0.2).round()),
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
        child: Icon(
          Icons.settings,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
