import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_issues/github_issues.dart';

const kOwner = 'abichinger';
const kRepo = 'github-issues-test';

late List<Label>? _labels;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _labels = await getLabels();

  runApp(const GithubIssuesExampleApp());
}

Future<String> get personalToken {
  return rootBundle.loadString('assets/token.txt');
}

Future<List<Label>> getLabels() async {
  final token = await personalToken;
  final github = Github(Authentication.token(token));

  return await github.getLabels(
    owner: kOwner,
    repo: kRepo,
  );
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
                      owner: kOwner,
                      repo: kRepo,
                      initialValue: const IssueRequest(title: "Hello World!"),
                      labels: _labels,
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
                      owner: kOwner,
                      repo: kRepo,
                      showTitle: false,
                      initialValue: const IssueRequest(title: "Hidden Title"),
                    );
                  },
                );
              },
              child: const Text('Give Feedback! (Only Comment)'),
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
    List<Label>? labels,
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
            labels: labels,
            onClose: () {
              Navigator.pop(context);
            },
            onSubmit: (issue) async {
              final navigator = Navigator.of(context);
              final token = await personalToken;
              final github = Github(Authentication.token(token));

              await github.createIssue(
                owner: owner,
                repo: repo,
                issue: issue,
              );

              navigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
