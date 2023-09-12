import 'package:flutter/widgets.dart';
import 'package:github_issues/src/l10n/l10n.dart';
import 'package:intl/locale.dart' as intl;

extension BuildContextExt on BuildContext {
  GithubIssuesLocalizations get l10n => L10nProvider.of(this).localizations;
}

Locale? tryParseLocale(String locale) {
  final intlLocale = intl.Locale.tryParse(locale);
  if (intlLocale == null) {
    return null;
  }

  return Locale.fromSubtags(
    languageCode: intlLocale.languageCode,
    countryCode: intlLocale.countryCode,
    scriptCode: intlLocale.scriptCode,
  );
}
