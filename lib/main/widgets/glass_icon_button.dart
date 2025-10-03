import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

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
      child: GlassmorphicContainer(
        width: width,
        height: height,
        borderRadius: borderRadius,
        blur: 15,
        alignment: Alignment.center,
        border: 0.0,
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
            Theme.of(context).colorScheme.outline.withAlpha((255 * 0.4).round()),
            Theme.of(context).colorScheme.outline.withAlpha((255 * 0.1).round()),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}