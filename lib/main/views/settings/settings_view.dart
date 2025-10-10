import 'package:counting_app/application/providers/locale_provider.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:counting_app/main/views/home/home_view.dart';
import 'package:counting_app/main/views/settings/language_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends ConsumerStatefulWidget {
  static const routeName = '/settings';

  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _isDarkMode = false;

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDarkMode ? Colors.white : onBackgroundColor;
    final selectedLocale = ref.watch(localeProvider);
    final selectedLanguage =
        _getLanguageName(selectedLocale?.languageCode ?? 'en');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!mounted) return;
        if (!didPop) {
          Navigator.of(context).pop();
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeView.routeName,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.settingMenuTitle,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(
                l10n.darkMode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkMode = value;
                    // TODO: Implement theme change logic
                  });
                },
                activeThumbColor: switchActiveColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: switchInactiveTrackColor,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ),
            ListTile(
              title: Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedLanguage,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : onBackgroundColor,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () async {
                if (!mounted) return;
                final result = await Navigator.of(context).pushNamed(
                  LanguageSelectionView.routeName,
                );
                if (!mounted) return;
                if (result == true) {
                  // LanguageSelectionView에서 true를 반환하면 언어가 변경된 것임
                  setState(() {});
                }
              },
            ),
            ListTile(
              title: Text(
                l10n.resetData,
                style: TextStyle(color: errorColor),
              ),
              onTap: () {
                // TODO: Implement data reset dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}