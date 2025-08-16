import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

// 탭할 때 리퀴드 글래스 효과가 나타나는 아이콘 버튼 위젯입니다.
class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // 컨트롤러의 값에 따라 스케일이 변하는 애니메이션을 정의합니다.
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 버튼을 누르면 애니메이션을 시작합니다.
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  // 버튼에서 손을 떼면 애니메이션을 되돌리고 콜백을 실행합니다.
  void _onTapUp(TapUpDetails details) {
    _controller.reverse().then((_) {
      widget.onPressed();
    });
  }

  // 탭을 취소하면 애니메이션을 되돌립니다.
  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 애니메이션에 따라 크기가 변하는 글래스 효과 컨테이너입니다.
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GlassmorphicContainer(
                  width: 52,
                  height: 52,
                  borderRadius: 26,
                  blur: 15,
                  alignment: Alignment.center,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDarkMode ? const Color.fromRGBO(255, 255, 255, 0.2) : const Color.fromRGBO(255, 255, 255, 0.3),
                      isDarkMode ? const Color.fromRGBO(255, 255, 255, 0.1) : const Color.fromRGBO(255, 255, 255, 0.2),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromRGBO(255, 255, 255, 0.5),
                      const Color.fromRGBO(255, 255, 255, 0.5),
                    ],
                  ),
                ),
              );
            },
          ),
          // 항상 위에 표시되는 아이콘입니다.
          Icon(widget.icon, color: widget.iconColor),
        ],
      ),
    );
  }
}
