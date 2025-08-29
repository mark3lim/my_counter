import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 앱의 Locale 상태를 관리하는 프로바이더입니다.
final localeProvider = StateProvider<Locale?>((ref) => const Locale('ko'));
