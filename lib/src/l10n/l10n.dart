import 'package:flutter/widgets.dart';
import 'package:github_issues/src/l10n/gen/app_localizations.dart';

export 'gen/app_localizations.dart';
export 'gen/app_localizations_en.dart';

class L10nProvider extends InheritedWidget {
  final GithubIssuesLocalizations localizations;

  const L10nProvider({
    super.key,
    required this.localizations,
    required super.child,
  });

  static L10nProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<L10nProvider>();
  }

  static L10nProvider of(BuildContext context) {
    final L10nProvider? result = maybeOf(context);
    assert(result != null, 'No L10nProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
