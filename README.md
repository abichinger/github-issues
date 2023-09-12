<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# Github Issues

[![Pub Version](https://img.shields.io/pub/v/github_issues.svg)](https://pub.dev/packages/github_issues)

Use Github issues to collect user feedback.

<img src="https://github.com/abichinger/github-issues/raw/main/screenshots/screenshots.png" alt="Screenshots">

## Features

- Create Github issues with title, comment and labels
- Easy internationalization with `GithubIssuesLocalizations`
- Supports two authentication methods

## Getting started

1. Create a repository to store the user feedback (or use an existing one).
2. Get a token with read and write access on issues for your repository <br />
**Option 1**: [Generate a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) <br />
**Option 2**: Create a [Github App](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app) -> [Install](https://docs.github.com/en/enterprise-cloud@latest/apps/using-github-apps/installing-your-own-github-app) your own Github App -> [Generate a private key](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps) for your Github App.

## Usage

[Full example](https://pub.dev/packages/github_issues/example)

**Fill input fields in advance**:

```dart
showDialog(
  context: context,
  builder: (context) {
    return GithubIssueDialog(
      github: Github(Authentication.token('PERSONAL_ACCESS_TOKEN'));,
      owner: 'OWNER',
      repo: 'REPO',
      initialValue: const IssueRequest(title: "Hello World!"),
    );
  },
);
```

**Pass your custom localizations**:

```dart
class CustomLocalization extends GithubIssuesLocalizationsEn {
  @override
  String get dialogTitle => 'Thanks for your feedback!';
}

showDialog(
  context: context,
  builder: (context) {
    return GithubIssueDialog(
      github: Github(Authentication.token('PERSONAL_ACCESS_TOKEN'));,
      owner: 'OWNER',
      repo: 'REPO',
      localizations: CustomLocalization(),
    );
  },
);
```

**Show only comment input**:

```dart
showDialog(
  context: context,
  builder: (context) {
    return GithubIssueDialog(
      github: Github(Authentication.token('PERSONAL_ACCESS_TOKEN'));,
      owner: 'OWNER',
      repo: 'REPO',
      showTitle: false,
      labels: null,
      initialValue: const IssueRequest(title: "Hidden Title"), // title is required
    );
  },
);
```