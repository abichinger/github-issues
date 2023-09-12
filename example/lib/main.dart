import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_issues/github_issues.dart';

const kOwner = 'abichinger';
const kRepo = 'github-issues-test';

late Github github;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await personalToken;
  github = Github(Authentication.token(token));

  runApp(const GithubIssuesExampleApp());
}

Future<String> get personalToken {
  return rootBundle.loadString('assets/token.txt');
}

class GithubIssuesExampleApp extends StatelessWidget {
  const GithubIssuesExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const GithubIssuesExample(),
    );
  }
}

class GithubIssuesExample extends StatelessWidget {
  const GithubIssuesExample({super.key});

  String colorToRadixString(Color color) {
    return color.value.toRadixString(16);
  }

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
                    return GithubIssueDialog(
                      github: github,
                      owner: kOwner,
                      repo: kRepo,
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
                    return GithubIssueDialog(
                      github: github,
                      owner: kOwner,
                      repo: kRepo,
                      initialValue: const IssueRequest(title: "Hello World!"),
                      labels: null,
                    );
                  },
                );
              },
              child: const Text('Feedback (labels hidden)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return GithubIssueDialog(
                      github: github,
                      owner: kOwner,
                      repo: kRepo,
                      showTitle: false,
                      labels: null,
                      initialValue: const IssueRequest(title: "Hidden Title"),
                    );
                  },
                );
              },
              child: const Text('Feedback (Only comment)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return GithubIssueDialog(
                      github: github,
                      owner: kOwner,
                      repo: kRepo,
                      localizations: CustomLocalization(),
                    );
                  },
                );
              },
              child: const Text('Feedback (Custom localization)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return GithubIssueDialog(
                      github: github,
                      owner: kOwner,
                      repo: kRepo,
                      labels: [
                        Label.custom(
                          name: 'bug',
                          color: colorToRadixString(Colors.red.shade600),
                        ),
                        Label.custom(
                          name: 'documentation',
                          color: colorToRadixString(Colors.blue.shade600),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Feedback (hardcoded labels)'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLocalization extends GithubIssuesLocalizationsEn {
  @override
  String get dialogTitle => 'Thanks for your feedback!';
}
