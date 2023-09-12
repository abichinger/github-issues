import 'app_localizations.dart';

/// The translations for German (`de`).
class GithubIssuesLocalizationsDe extends GithubIssuesLocalizations {
  GithubIssuesLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get dialogTitle => 'Feedback';

  @override
  String get dialogDescription => 'Teile uns mit, wie wir unsere App verbessern können';

  @override
  String get title => 'Titel';

  @override
  String get titleBlank => 'Titel darf nicht leer sein';

  @override
  String get titleTooLong => 'Titel ist zu lang (maximal 256 Zeichen)';

  @override
  String get body => 'Kommentar';

  @override
  String get labels => 'Labels';

  @override
  String get noLabels => 'keine';

  @override
  String get done => 'Senden';

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'Ok';
}
