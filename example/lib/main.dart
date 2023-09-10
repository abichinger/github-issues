import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_issues/github_issues.dart';

Future<String> get personalToken {
  return rootBundle.loadString('assets/token.txt');
}

void main() {
  runApp(const GithubIssuesExampleApp());
}

class GithubIssuesExampleApp extends StatelessWidget {
  const GithubIssuesExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const GithubIssuesExample(),
    );
  }
}

class GithubIssuesExample extends StatelessWidget {
  const GithubIssuesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Issues - Example'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return _buildDialog(
                      context,
                      owner: 'abichinger',
                      repo: 'github-issues-test',
                      initialValue: const IssueRequest(title: "Hello World!"),
                    );
                  },
                );
              },
              child: const Text('Give Feedback!'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return _buildDialog(
                      context,
                      owner: 'abichinger',
                      repo: 'github-issues-test',
                      showTitle: false,
                      initialValue: const IssueRequest(title: "Hidden Title"),
                    );
                  },
                );
              },
              child: const Text('Give Feedback! (Hidden Title)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialog(
    BuildContext context, {
    required String owner,
    required String repo,
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
                owner: owner,
                repo: repo,
                issue: issue,
              );

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
