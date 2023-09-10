import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:github_issues/github_issues.dart';

Future<Github> get _app async {
  final pemFile = File('./assets/private.pem');
  final pem = await pemFile.readAsString();

  final auth = Authentication.pem(
    id: 385403,
    pem: pem,
  );
  return Github(auth);
}

void main() {
  test('Github getName', () async {
    final app = await _app;
    final name = await app.getName();
    expect(name, 'Nono Battle Feedback');
  });

  test('Github getInstallationId', () async {
    final app = await _app;
    final id = await app.getInstallationId(
      owner: 'abichinger',
      repo: 'github-issues-test',
    );
    expect(id >= 0, true);
  });

  test('Github getInstallationToken', () async {
    final app = await _app;
    final id = await app.getInstallationId(
      owner: 'abichinger',
      repo: 'github-issues-test',
    );
    final token = await app.getInstallationToken(id);
    expect(token.startsWith('ghs_'), true);
  });

  test('Github createIssue (pem)', () async {
    final pemFile = File('./assets/private.pem');
    final pem = await pemFile.readAsString();
    final auth = PrivateKeyAuth(
      id: 385403,
      pem: pem,
    );
    final token = await auth.getInstallationToken(
      owner: 'abichinger',
      repo: 'github-issues-test',
    );

    final app = Github(Authentication.token(token));
    final created = await app.createIssue(
      owner: 'abichinger',
      repo: 'github-issues-test',
      issue: const IssueRequest(title: "Hello World (Github App)"),
    );
    expect(created, true);
  });

  test('Github createIssue (personal token)', () async {
    final tokenFile = File('./assets/token.txt');
    final token = await tokenFile.readAsString();

    final app = Github(Authentication.token(token));
    final created = await app.createIssue(
      owner: 'abichinger',
      repo: 'github-issues-test',
      issue: const IssueRequest(title: "Hello World (Personal Token)"),
    );
    expect(created, true);
  });

  test('Github createIssue (invalid token)', () async {
    final app = Github(Authentication.token("invalid"));
    expect(
        app.createIssue(
          owner: 'abichinger',
          repo: 'github-issues-test',
          issue: const IssueRequest(title: "Hello World (Personal Token)"),
        ),
        throwsA(const TypeMatcher<ResponseException>()));
  });
}
