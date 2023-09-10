import 'dart:io';

import 'package:github_issues/github_issues.dart';

const appId = 385403;
const owner = 'abichinger';
const repo = 'github-issues-test';

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
