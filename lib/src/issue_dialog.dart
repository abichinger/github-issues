import 'package:flutter/material.dart';
import 'package:github_issues/github_issues.dart';
import 'package:github_issues/src/flutter_util.dart';
import 'package:intl/intl.dart';

/// A dialog to create github issues with [IssueRequest.title], [IssueRequest.body] and [IssueRequest.labels].
class GithubIssueDialog extends StatefulWidget {
  /// Github API wrapper
  final Github github;

  /// The account owner of the repository
  final String owner;

  /// The name of the repository without the .git extension
  final String repo;

  /// The constraints of the dialog content
  final BoxConstraints constraints;

  /// The initial value of the form fields. Make sure to set an initial value for [IssueRequest.title] if [showTitle] is false
  final IssueRequest? initialValue;

  /// Vertical spacing between form fields
  final double spacing;

  /// Sets the visibility of the title field.
  final bool showTitle;

  /// [InputDecoration] of title field
  final InputDecoration? titleDecoration;

  /// [FormFieldValidator] of title field
  final String? Function(String?)? titleValidator;

  /// Sets the visibility of the comment field.
  final bool showBody;

  /// [InputDecoration] of comment field
  final InputDecoration? bodyDecoration;

  /// [FormFieldValidator] of comment field
  final String? Function(String?)? bodyValidator;

  /// A List of Github issue labels
  ///
  /// By omitting this parameter, all available labels will be fetched from Github.
  ///
  /// If null is passed, then the label input will be hidden.
  final List<Label>? labels;

  /// An optional localization object. Can be used to override the default localization
  final GithubIssuesLocalizations? localizations;

  const GithubIssueDialog({
    super.key,
    required this.github,
    required this.owner,
    required this.repo,
    this.initialValue,
    this.showTitle = true,
    this.titleDecoration,
    this.titleValidator,
    this.showBody = true,
    this.bodyDecoration,
    this.bodyValidator,
    this.spacing = 16,
    this.labels = const [],
    this.localizations,
    this.constraints = const BoxConstraints(maxWidth: 500),
  });

  @override
  State<GithubIssueDialog> createState() => _GithubIssueDialogState();
}

class _GithubIssueDialogState extends State<GithubIssueDialog> {
  List<Label>? labels;

  @override
  void initState() {
    labels = widget.labels;
    if (showLabels && widget.labels!.isEmpty) {
      widget.github
          .getLabels(owner: widget.owner, repo: widget.repo)
          .then((value) {
        setState(() {
          labels = value;
        });
      });
    }
    super.initState();
  }

  bool get showLabels => widget.labels != null;

  GithubIssuesLocalizations get localizations {
    if (widget.localizations != null) {
      return widget.localizations!;
    }

    final locale = tryParseLocale(Intl.getCurrentLocale());
    if (locale != null &&
        GithubIssuesLocalizations.delegate.isSupported(locale)) {
      return lookupGithubIssuesLocalizations(locale);
    }
    return GithubIssuesLocalizationsEn();
  }

  @override
  Widget build(BuildContext context) {
    return L10nProvider(
      localizations: localizations,
      child: Builder(
        builder: (context) => _buildDialog(context),
      ),
    );
  }

  _buildDialog(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      scrollable: true,
      title: Text(
        l10n.dialogTitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: ConstrainedBox(
        constraints: widget.constraints,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dialogDescription),
            const SizedBox(height: 20),
            GithubIssueForm(
              showTitle: widget.showTitle,
              initialValue: widget.initialValue,
              labels: labels,
              onClose: () {
                Navigator.pop(context);
              },
              onSubmit: (issue) async {
                final navigator = Navigator.of(context);

                await widget.github.createIssue(
                  owner: widget.owner,
                  repo: widget.repo,
                  issue: issue,
                );

                navigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
