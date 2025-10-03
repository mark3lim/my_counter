import 'package:counting_app/application/providers/locale_provider.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/views/counting/basic_counting_view.dart';
import 'package:counting_app/main/views/home/home_view.dart';
import 'package:counting_app/main/views/settings/hidden_lists_view.dart';
import 'package:counting_app/main/views/settings/language_selection_view.dart';
import 'package:counting_app/main/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱의 진입점입니다.
void main() {
  // Riverpod을 사용하기 위해 ProviderScope로 앱을 감싸줍니다.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  /// MyApp 위젯의 생성자입니다.
  const MyApp({super.key});

  /// 이 위젯은 애플리케이션의 루트입니다.
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // onGenerateTitle을 사용하여 현지화된 앱 제목을 제공합니다.
      // 문자열 키는 ARB 파일(e.g. lib/l10n/app_en.arb)에 정의하세요: { "appTitle": "Counting App" }
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
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
      locale: locale, // 프로바이더가 제공하는 locale을 사용합니다.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: HomeView.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeView.routeName:
            return MaterialPageRoute(settings: settings, builder: (context) => const HomeView());
          case BasicCountingView.routeName:
            return MaterialPageRoute(settings: settings, builder: (context) => const BasicCountingView());
          case SettingsView.routeName:
            return MaterialPageRoute(settings: settings, builder: (context) => const SettingsView());
          case LanguageSelectionView.routeName:
            return MaterialPageRoute<bool>(settings: settings, builder: (context) => const LanguageSelectionView());
          case HiddenListsView.routeName:
            return MaterialPageRoute(settings: settings, builder: (context) => const HiddenListsView());
          default:
            // Handle unknown routes, maybe navigate to a default screen
            return MaterialPageRoute(settings: settings, builder: (context) => const HomeView());
        }
      },
    );
  }
}
