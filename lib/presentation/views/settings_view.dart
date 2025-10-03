import 'package:counting_app/application/providers/locale_provider.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/utils/color_and_style_utils.dart';
import 'package:counting_app/presentation/views/language_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:counting_app/presentation/views/home_view.dart'; // HomeView import 추가

class SettingsView extends ConsumerStatefulWidget {
  static const routeName = '/settings';

  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _isDarkMode = false;
  bool _languageChanged = false; // 언어 변경 여부를 추적하는 플래그

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
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (_languageChanged) {
          // 언어가 변경되었으면 HomeView로 돌아갈 때 스택을 모두 지움
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeView.routeName,
            (route) => false,
          );
        } else {
          // 언어가 변경되지 않았으면 단순히 이전 화면으로 돌아감
          Navigator.of(context).pop();
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
                final result = await Navigator.of(context).pushNamed(
                  LanguageSelectionView.routeName,
                );
                if (result == true) {
                  // LanguageSelectionView에서 true를 반환하면 언어가 변경된 것임
                  setState(() {
                    _languageChanged = true;
                  });
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