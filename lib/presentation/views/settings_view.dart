import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/views/language_selection_view.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isDarkMode = false;
  String _selectedLanguage = '한국어';

  Future<void> _navigateAndSelectLanguage(BuildContext context) async {
    final result = await Navigator.pushNamed<String>(
      context, 
      LanguageSelectionView.routeName
      );

    if (!mounted) return;
    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedLanguage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
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
              activeThumbColor: Color(0xFF5478E4),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Color(0xFFE0E0E0),
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
                  _selectedLanguage,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              _navigateAndSelectLanguage(context);
            },
          ),
          ListTile(
            title: Text(
              l10n.resetData,
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // TODO: Implement data reset dialog
            },
          ),
        ],
      ),
    );
  }
}
