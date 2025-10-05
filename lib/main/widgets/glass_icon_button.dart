import 'package:flutter/material.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final double width;
  final double height;
  final double borderRadius;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.black,
    this.width = 56,
    this.height = 56,
    this.borderRadius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.transparent, width: 0),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}