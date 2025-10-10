import 'package:flutter/material.dart';

class EventColor {
  final Color color;

  const EventColor({required this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventColor &&
          runtimeType == other.runtimeType &&
          color == other.color;

  static const EventColor defaultColor = EventColor(color: Color(0xFF999BA0));
  static const EventColor monthColor   = EventColor(color: Color(0xFF0066FF));
  static const EventColor weekColor    = EventColor(color: Color(0xFFE54C50));
  static const EventColor dayColor     = EventColor(color: Color(0xFFFF8C11));

  @override
  int get hashCode => color.hashCode;
}