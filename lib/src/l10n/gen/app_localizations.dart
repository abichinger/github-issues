import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of GithubIssuesLocalizations
/// returned by `GithubIssuesLocalizations.of(context)`.
///
/// Applications need to include `GithubIssuesLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GithubIssuesLocalizations.localizationsDelegates,
///   supportedLocales: GithubIssuesLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the GithubIssuesLocalizations.supportedLocales
/// property.
abstract class GithubIssuesLocalizations {
  GithubIssuesLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GithubIssuesLocalizations? of(BuildContext context) {
    return Localizations.of<GithubIssuesLocalizations>(context, GithubIssuesLocalizations);
  }

  static const LocalizationsDelegate<GithubIssuesLocalizations> delegate = _GithubIssuesLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @dialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get dialogTitle;

  /// No description provided for @dialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Let us know how we can improve our app.'**
  String get dialogDescription;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleBlank.
  ///
  /// In en, this message translates to:
  /// **'Title can\'t be blank'**
  String get titleBlank;

  /// No description provided for @titleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Title is too long (maximum is 256 characters)'**
  String get titleTooLong;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get body;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @noLabels.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get noLabels;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;
}

class _GithubIssuesLocalizationsDelegate extends LocalizationsDelegate<GithubIssuesLocalizations> {
  const _GithubIssuesLocalizationsDelegate();

  @override
  Future<GithubIssuesLocalizations> load(Locale locale) {
    return SynchronousFuture<GithubIssuesLocalizations>(lookupGithubIssuesLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_GithubIssuesLocalizationsDelegate old) => false;
}

GithubIssuesLocalizations lookupGithubIssuesLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return GithubIssuesLocalizationsDe();
    case 'en': return GithubIssuesLocalizationsEn();
  }

  throw FlutterError(
    'GithubIssuesLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
