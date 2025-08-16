import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/views/basic_counting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:counting_app/presentation/views/home_view.dart';

/// 앱의 진입점입니다.
void main() {
  // Riverpod을 사용하기 위해 ProviderScope로 앱을 감싸줍니다.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  /// MyApp 위젯의 생성자입니다.
  const MyApp({super.key});

  /// 이 위젯은 애플리케이션의 루트입니다.
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counting App',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: HomeView.routeName,
      routes: {
        HomeView.routeName: (context) => const HomeView(),
        BasicCountingView.routeName: (context) => const BasicCountingView(),
      },
    );
  }
}
