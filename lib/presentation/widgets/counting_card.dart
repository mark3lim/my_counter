import 'package:flutter/material.dart';

class CountingCard extends StatefulWidget {
  // 카드에 표시될 텍스트입니다.
  final String text;

  // 카드를 눌렀을 때 실행될 콜백 함수입니다.
  final VoidCallback? onTap;

  // 텍스트 정렬을 위한 속성입니다.
  final TextAlign textAlign;

  // 카드에 표시될 아이콘입니다.
  final IconData? icon;

  // backgroud color
  final Color? backgroundColor;

  const CountingCard({
    super.key,
    required this.text,
    this.onTap,
    this.textAlign = TextAlign.center, // 기본값은 중앙 정렬입니다.
    this.icon = Icons.list_alt,
    this.backgroundColor = const Color(0xFFD0E4FF),
  });

  @override
  State<CountingCard> createState() => _CountingCardState();
}

class _CountingCardState extends State<CountingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse().then((_) {
      widget.onTap?.call();
    });
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.backgroundColor;
    final highlightColor = Colors.grey.shade200;

    // 터치 이벤트를 감지하는 위젯입니다.
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Card(
            elevation: 2.0,
            color: Color.lerp(cardColor, highlightColor, _controller.value),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SizedBox(
              height: 70,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: 24.0,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 12.0),
                    ],
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: widget.textAlign,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
