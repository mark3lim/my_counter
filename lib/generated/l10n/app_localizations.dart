import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'카운팅 앱'**
  String get appTitle;

  /// No description provided for @newCounting.
  ///
  /// In ko, this message translates to:
  /// **'새로운 카운트'**
  String get newCounting;

  /// No description provided for @addNewCounting.
  ///
  /// In ko, this message translates to:
  /// **'새로운 카운트 추가'**
  String get addNewCounting;

  /// No description provided for @addList.
  ///
  /// In ko, this message translates to:
  /// **'항목 추가'**
  String get addList;

  /// No description provided for @listName.
  ///
  /// In ko, this message translates to:
  /// **'항목 이름'**
  String get listName;

  /// No description provided for @add.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get add;

  /// No description provided for @ok.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @listExists.
  ///
  /// In ko, this message translates to:
  /// **'이미 존재하는 항목 입니다.'**
  String get listExists;

  /// No description provided for @okayBtn.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get okayBtn;

  /// No description provided for @nextBtn.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get nextBtn;

  /// No description provided for @prevBtn.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get prevBtn;

  /// No description provided for @detailSetting.
  ///
  /// In ko, this message translates to:
  /// **'상세 설정'**
  String get detailSetting;

  /// No description provided for @nameInputTitle.
  ///
  /// In ko, this message translates to:
  /// **'이름 설정'**
  String get nameInputTitle;

  /// No description provided for @nameInputHint.
  ///
  /// In ko, this message translates to:
  /// **'필수 입력'**
  String get nameInputHint;

  /// No description provided for @useNegativeNum.
  ///
  /// In ko, this message translates to:
  /// **'음수 사용'**
  String get useNegativeNum;

  /// No description provided for @hideToggle.
  ///
  /// In ko, this message translates to:
  /// **'숨기기'**
  String get hideToggle;

  /// No description provided for @saveBtn.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get saveBtn;

  /// No description provided for @checkDeleteTitle.
  ///
  /// In ko, this message translates to:
  /// **'삭제 확인'**
  String get checkDeleteTitle;

  /// No description provided for @checkDeleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'항목을 정말 삭제하시겠습니까?'**
  String get checkDeleteMessage;

  /// No description provided for @saveFailedMessage.
  ///
  /// In ko, this message translates to:
  /// **'저장에 실패했습니다. 다시 시도해주세요.'**
  String get saveFailedMessage;

  /// No description provided for @deleteFailedMessage.
  ///
  /// In ko, this message translates to:
  /// **'삭제에 실패했습니다. 다시 시도해주세요.'**
  String get deleteFailedMessage;

  /// No description provided for @dataLoadingErrorMessage.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러오는 중 오류가 발생했습니다.'**
  String get dataLoadingErrorMessage;

  /// No description provided for @useAnalyzTitle.
  ///
  /// In ko, this message translates to:
  /// **'통계 사용'**
  String get useAnalyzTitle;

  /// No description provided for @general.
  ///
  /// In ko, this message translates to:
  /// **'기본'**
  String get general;

  /// No description provided for @daily.
  ///
  /// In ko, this message translates to:
  /// **'일별'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In ko, this message translates to:
  /// **'주간'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In ko, this message translates to:
  /// **'월간'**
  String get monthly;

  /// No description provided for @countingType.
  ///
  /// In ko, this message translates to:
  /// **'카운팅 타입'**
  String get countingType;

  /// No description provided for @editCounting.
  ///
  /// In ko, this message translates to:
  /// **'카운트 수정'**
  String get editCounting;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @showHiddenLists.
  ///
  /// In ko, this message translates to:
  /// **'숨겨진 목록 보기'**
  String get showHiddenLists;

  /// No description provided for @language.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// No description provided for @languageSettingTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSettingTitle;

  /// No description provided for @settingMenuTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정 메뉴'**
  String get settingMenuTitle;

  /// No description provided for @darkMode.
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get darkMode;

  /// No description provided for @resetData.
  ///
  /// In ko, this message translates to:
  /// **'데이터 초기화'**
  String get resetData;

  /// No description provided for @noHiddenItems.
  ///
  /// In ko, this message translates to:
  /// **'숨겨진 항목이 없습니다.'**
  String get noHiddenItems;

  /// No description provided for @addCategoryHint.
  ///
  /// In ko, this message translates to:
  /// **'엔터키로 카테고리 추가 가능합니다'**
  String get addCategoryHint;

  /// No description provided for @language_ko.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get language_ko;

  /// No description provided for @language_en.
  ///
  /// In ko, this message translates to:
  /// **'영어'**
  String get language_en;

  /// No description provided for @language_ja.
  ///
  /// In ko, this message translates to:
  /// **'일본어'**
  String get language_ja;

  /// No description provided for @language_es.
  ///
  /// In ko, this message translates to:
  /// **'스페인어'**
  String get language_es;

  /// No description provided for @dataNumberLimitError.
  ///
  /// In ko, this message translates to:
  /// **'카테고리는 최대 100개까지만 저장할 수 있습니다.'**
  String get dataNumberLimitError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
