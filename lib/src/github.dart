import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:github_issues/src/util.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'github.g.dart';

class Authentication {
  Map<String, String> get headers {
    return {};
  }

  Authentication();

  factory Authentication.token(String token) {
    return JWTAuth(token);
  }

  factory Authentication.pem({
    required int id,
    required String pem,
  }) {
    return PrivateKeyAuth(id: id, pem: pem);
  }
}

class JWTAuth extends Authentication {
  final String token;

  JWTAuth(this.token);

  @override
  Map<String, String> get headers {
    return {
      'Authorization': 'Bearer $token',
    };
  }
}

class PrivateKeyAuth extends Authentication {
  final int id;
  final String pem;

  PrivateKeyAuth({required this.id, required this.pem});

  // Generating a JSON Web Token (JWT) for a GitHub App
  // https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-json-web-token-jwt-for-a-github-app
  String createSignedJWT() {
    final jwt = JWT(
      {
        'iss': id,
        // 60 seconds in the past to allow for clock drift
        'iat': secondsSinceEpoch() - 60,
        // JWT expiration time (5 min)
        'exp': secondsSinceEpoch() + (5 * 60)
      },
    );

    return jwt.sign(RSAPrivateKey(pem), algorithm: JWTAlgorithm.RS256);
  }

  @override
  Map<String, String> get headers {
    final token = createSignedJWT();
    return {
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> getInstallationToken({
    required String owner,
    required String repo,
  }) async {
    var app = Github(this);
    final installationId = await app.getInstallationId(
      owner: owner,
      repo: repo,
    );
    return await app.getInstallationToken(installationId);
  }
}

class Github {
  static const baseUrl = 'https://api.github.com';

  final Authentication auth;

  final _client = http.Client();

  Github(this.auth);

  Map<String, String>? get _headers {
    return {
      ...auth.headers,
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
  }

  // https://docs.github.com/en/rest/apps/apps?apiVersion=2022-11-28#get-a-repository-installation-for-the-authenticated-app
  Future<String> getName() async {
    final url = Uri.parse('$baseUrl/app');

    final res = await _client.get(url, headers: _headers);
    assertStatusCode(200, res);

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return json['name'];
  }

  // Authenticating as a GitHub App installation
  // https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/authenticating-as-a-github-app-installation
  //
  // https://docs.github.com/en/rest/apps/apps?apiVersion=2022-11-28#get-a-repository-installation-for-the-authenticated-app

  Future<int> getInstallationId({
    required String owner,
    required String repo,
  }) async {
    final url = Uri.parse('$baseUrl/repos/$owner/$repo/installation');

    final res = await _client.get(url, headers: _headers);
    assertStatusCode(200, res);

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return json['id'];
  }

  // https://docs.github.com/en/rest/apps/apps?apiVersion=2022-11-28#create-an-installation-access-token-for-an-app
  Future<String> getInstallationToken(int installationId) async {
    final url =
        Uri.parse('$baseUrl/app/installations/$installationId/access_tokens');

    final res = await _client.post(url, headers: _headers);
    assertStatusCode(201, res);

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return json['token'];
  }

  // https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#create-an-issue
  Future<bool> createIssue(
      {required String owner,
      required String repo,
      required IssueRequest issue}) async {
    final url = Uri.parse('$baseUrl/repos/$owner/$repo/issues');

    final res =
        await _client.post(url, headers: _headers, body: jsonEncode(issue));
    assertStatusCode(201, res);

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return json['state'] == 'open';
  }
}

class ResponseException implements Exception {
  final int expected;
  final http.Response response;

  ResponseException(this.expected, this.response);

  @override
  String toString() {
    final request = response.request;

    return ''' ResponseException: ${request?.method.toUpperCase()} ${request?.url}

Expected: $expected
Actual: ${response.statusCode}

Body: ${response.body}
''';
  }

  String? get message {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['message'] ?? 'Ups! Something went wrong';
    } catch (e) {
      return null;
    }
  }
}

assertStatusCode(int expected, http.Response res) {
  if (expected != res.statusCode) {
    throw ResponseException(expected, res);
  }
}

@JsonSerializable(includeIfNull: false)
class IssueRequest {
  final String title;
  final String? body;
  final String? assignee;
  final int? milestone;
  final List<String>? labels;
  final List<String>? assignees;

  const IssueRequest({
    required this.title,
    this.body,
    this.assignee,
    this.milestone,
    this.labels,
    this.assignees,
  });

  IssueRequest copyWith({
    String? title,
    String? body,
    String? assignee,
    int? milestone,
    List<String>? labels,
    List<String>? assignees,
  }) {
    return IssueRequest(
      title: title ?? this.title,
      body: body ?? this.body,
      assignee: assignee ?? this.assignee,
      milestone: milestone ?? this.milestone,
      labels: labels ?? this.labels,
      assignees: assignees ?? this.assignees,
    );
  }

  factory IssueRequest.fromJson(Map<String, dynamic> json) =>
      _$IssueRequestFromJson(json);
  Map<String, dynamic> toJson() => _$IssueRequestToJson(this);
}
