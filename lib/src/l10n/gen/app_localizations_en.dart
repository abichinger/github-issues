import 'app_localizations.dart';

/// The translations for English (`en`).
class GithubIssuesLocalizationsEn extends GithubIssuesLocalizations {
  GithubIssuesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dialogTitle => 'Feedback';

  @override
  String get dialogDescription => 'Let us know how we can improve our app.';

  @override
  String get title => 'Title';

  @override
  String get titleBlank => 'Title can\'t be blank';

  @override
  String get titleTooLong => 'Title is too long (maximum is 256 characters)';

  @override
  String get body => 'Comment';

  @override
  String get labels => 'Labels';

  @override
  String get noLabels => 'None yet';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'Ok';
}
