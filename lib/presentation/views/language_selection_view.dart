import 'package:counting_app/application/providers/locale_provider.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelectionView extends ConsumerWidget {
  static const routeName = '/language-selection';

  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(localeProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.languageSettingTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: ListView(
        children: [
          // 한국어
          ListTile(
            title: const Text('한국어'),
            trailing: selectedLocale?.languageCode == 'ko'
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              ref.read(localeProvider.notifier).state = const Locale('ko');
              Navigator.pop(context);
            },
          ),
          // 영어
          ListTile(
            title: const Text('English'),
            trailing: selectedLocale?.languageCode == 'en'
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              ref.read(localeProvider.notifier).state = const Locale('en');
              Navigator.pop(context);
            },
          ),
          // 일본어
          ListTile(
            title: const Text('日本語'),
            trailing: selectedLocale?.languageCode == 'ja'
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              ref.read(localeProvider.notifier).state = const Locale('ja');
              Navigator.pop(context);
            },
          ),
          // 스페인어
          ListTile(
            title: const Text('Español'),
            trailing: selectedLocale?.languageCode == 'es'
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              ref.read(localeProvider.notifier).state = const Locale('es');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
