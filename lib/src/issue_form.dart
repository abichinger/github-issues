import 'package:flutter/material.dart';
import 'package:github_issues/src/github.dart';
import 'package:github_issues/src/multi_select.dart';

class GithubIssueForm extends StatefulWidget {
  final IssueRequest? initialValue;
  final double spacing;

  final bool showTitle;
  final InputDecoration? titleDecoration;
  final String? Function(String?)? titleValidator;

  final bool showBody;
  final InputDecoration? bodyDecoration;
  final String? Function(String?)? bodyValidator;

  final Future<void> Function(IssueRequest issue) onSubmit;
  final Function()? onClose;

  final List<Label>? labels;

  const GithubIssueForm({
    super.key,
    this.initialValue,
    required this.onSubmit,
    this.onClose,
    this.showTitle = true,
    this.titleDecoration,
    this.titleValidator,
    this.showBody = true,
    this.bodyDecoration,
    this.bodyValidator,
    this.spacing = 16,
    this.labels,
  });

  @override
  State<GithubIssueForm> createState() => _GithubIssueFormState();
}

class _GithubIssueFormState extends State<GithubIssueForm> {
  final _formKey = GlobalKey<FormState>();
  late IssueRequest issue;
  Map<String, Label> labelMap = {};
  List<Label> _selectedLabels = [];
  String error = "";

  List<Label> get selectedLabels => _selectedLabels;

  set selectedLabels(List<Label> value) {
    _selectedLabels = value;
    setState(() {
      issue = issue.copyWith(
        labels: value.map((label) => label.name).toList(),
      );
    });
  }

  @override
  void initState() {
    issue = widget.initialValue?.copyWith() ?? const IssueRequest(title: "");

    for (final label in widget.labels ?? []) {
      labelMap[label.name] = label;
    }

    _selectedLabels = issue.labels
            ?.map((label) => labelMap[label])
            .whereType<Label>()
            .toList() ??
        [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double hSpacing = 8;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showTitle) ...[
            _buildTitle(),
            SizedBox(height: widget.spacing),
          ],
          if (widget.showBody) ...[
            _buildBody(),
            SizedBox(height: widget.spacing),
          ],
          if (widget.labels != null) _buildLabels(),
          if (error.isNotEmpty) _buildError(),
          SizedBox(height: widget.spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onClose != null)
                TextButton(
                    onPressed: widget.onClose, child: const Text('Close')),
              const SizedBox(
                width: hSpacing,
              ),
              AsyncElevatedButton(
                onPressed: () async {
                  await _submit();
                },
                child: const Text('Done'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return TextFormField(
      initialValue: issue.title,
      validator: widget.titleValidator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Title can\'t be blank';
            }
            if (value.length > 256) {
              return 'Title is too long (maximum is 256 characters)';
            }
            return null;
          },
      decoration: widget.titleDecoration ??
          const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
      maxLines: 1,
      onSaved: (value) {
        issue = issue.copyWith(title: value ?? "");
      },
    );
  }

  Widget _buildBody() {
    return TextFormField(
      initialValue: issue.body,
      validator: widget.bodyValidator,
      decoration: widget.bodyDecoration ??
          const InputDecoration(
            labelText: 'Comment',
            border: OutlineInputBorder(),
          ),
      minLines: 3,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      onSaved: (value) {
        issue = issue.copyWith(body: value);
      },
    );
  }

  Widget _buildLabels() {
    return ListTile(
      title: const Text('Labels'),
      subtitle: selectedLabels.isEmpty
          ? const Text('None yet')
          : Wrap(
              children: selectedLabels.map((label) {
                final item = LabelItem(label);

                return ChipTheme(
                  data: item.chipThemeData,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        label.name,
                        style: TextStyle(
                          color: item.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
      trailing: const Icon(Icons.settings),
      onTap: () async {
        final newLabels = await _selectLabels();
        if (newLabels == null) {
          return;
        }
        selectedLabels = newLabels;
      },
    );
  }

  Future<List<Label>?> _selectLabels() {
    final items =
        (widget.labels ?? []).map((label) => LabelItem(label)).toList();
    final initialValue =
        selectedLabels.map((label) => LabelItem(label)).toList();

    return MultiSelect.dialog<Label, LabelItem>(
      title: const Text(
        'Labels',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      context: context,
      items: items,
      initialValue: initialValue,
    );
  }

  // https://stackoverflow.com/a/68680939/3140799
  bool get isDarkMode {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark;
  }

  Widget _buildError() {
    final color =
        isDarkMode ? Colors.red.shade900.withOpacity(0.8) : Colors.red.shade300;
    final textColor =
        isDarkMode ? Colors.white70 : Colors.black.withOpacity(0.7);

    return Card(
      color: color,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            error,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    var formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    formState.save();
    if (!formState.validate()) {
      return;
    }

    try {
      await widget.onSubmit(issue.copyWith());
      setState(() {
        error = "";
      });
    } on ResponseException catch (e) {
      setState(() {
        error = e.message ?? "";
      });
    }
  }
}

class LabelItem extends MultiSelectItem<Label> {
  final Label _value;

  LabelItem(Label value) : _value = value;

  @override
  Color get color {
    return Color(
      int.tryParse("ff${value.color}", radix: 16) ?? Colors.white.value,
    );
  }

  @override
  Color get textColor {
    return Color.lerp(color, Colors.white, 0.6) ?? Colors.white;
  }

  @override
  String get text => _value.name;

  @override
  Label get value => _value;

  @override
  ChipThemeData get chipThemeData {
    final backgroundColor = Color.lerp(color, Colors.black, 0.4);

    return ChipThemeData(
      backgroundColor: backgroundColor,
      selectedColor: backgroundColor,
      checkmarkColor: textColor,
      shape: StadiumBorder(
        side: BorderSide(
          color: textColor,
        ),
      ),
    );
  }
}

class AsyncElevatedButton extends StatefulWidget {
  final Future<dynamic> Function()? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const AsyncElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<AsyncElevatedButton> createState() => _AsyncElevatedButtonState();
}

class _AsyncElevatedButtonState extends State<AsyncElevatedButton> {
  bool loading = false;

  set future(Future<dynamic> value) {
    setState(() {
      loading = true;
    });
    value.whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton(
          style: widget.style,
          onPressed: widget.onPressed != null && !loading
              ? () {
                  future = widget.onPressed!();
                }
              : null,
          child: Opacity(
            opacity: loading ? 0 : 1,
            child: widget.child,
          ),
        ),
        if (loading)
          const Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
