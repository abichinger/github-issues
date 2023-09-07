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

Use Github issues to collect user feedback.

<img src="https://github.com/abichinger/github-issues/raw/main/screenshots/screenshots.png" alt="Screenshots">

## Getting started

1. Create a repository to store the user feedback (or use an existing one).
2. Get a token with read and write access on issues for your repository <br />
**Option 1**: [Generate a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) <br />
**Option 2**: Create a [Github App](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app) -> [Install](https://docs.github.com/en/enterprise-cloud@latest/apps/using-github-apps/installing-your-own-github-app) your own Github App -> [Generate a private key](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps) for your Github App.

## Usage

### Dart

```dart
import 'dart:io';

import 'package:github_issues/github_issues.dart';

const appId = 385403;
const owner = 'abichinger';
const repo = 'nonobattle-issues';

// Personal access token
Future<String> get personalToken {
  return File('assets/token.txt').readAsString();
}

// Installation token of Github app
Future<String> get installationToken async {
  final pem = await File('assets/private.pem').readAsString();
  return PrivateKeyAuth(id: appId, pem: pem)
      .getInstallationToken(owner: owner, repo: repo);
}

void main() async {
  final token = await personalToken;
  // final token = await installationToken;

  final github = Github(Authentication.token(token));
  github.createIssue(
    owner: owner,
    repo: repo,
    issue: const IssueRequest(
      title: 'Hello World!',
      body: '...',
      labels: ['bug'],
    ),
  );
}
```

### Flutter

[Full example](https://pub.dev/packages/github_issues/example)

```dart
import 'package:github_issues/github_issues.dart';

Widget _buildDialog(
  BuildContext context, {
  bool showTitle = true,
  IssueRequest? initialValue,
}) {
  return AlertDialog(
    scrollable: true,
    title: const Text(
      'Thanks for your feedback!',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    content: Column(
      children: [
        const Text('Let us know how we can improve this example.'),
        const SizedBox(height: 16),
        GithubIssueForm(
          showTitle: showTitle,
          initialValue: initialValue,
          onClose: () {
            Navigator.pop(context);
          },
          onSubmit: (issue) async {
            final token = await personalToken;
            final github = Github(Authentication.token(token));

            await github.createIssue(
              owner: 'abichinger',
              repo: 'nonobattle-issues',
              issue: issue,
            );

            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
```
