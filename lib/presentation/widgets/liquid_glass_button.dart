import 'package:flutter/material.dart';

// Liquid Glass 디자인을 적용한 버튼 위젯입니다.
class LiquidGlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  // LiquidGlassButton 객체를 생성합니다.
  const LiquidGlassButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // iOS 26 liquid glass 디자인을 구현합니다.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: SizedBox.square(
        dimension: 48,
        child: Center(
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(240), // Opacity 1.0
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withAlpha(240), // Opacity 1.0
                  color.withAlpha(240), // Opacity 1.0
                ],
              ),
              border: Border.all(
                color: Colors.white.withAlpha(153), // Opacity 0.6
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
