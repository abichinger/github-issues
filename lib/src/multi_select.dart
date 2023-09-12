import 'package:flutter/material.dart';

abstract class MultiSelectItem<T> {
  T get value;
  String get text;
  Color get color;
  Color get textColor;
  ChipThemeData get chipThemeData;
}

class MultiSelectThemeData {
  final BoxConstraints constraints;

  const MultiSelectThemeData({this.constraints = const BoxConstraints()});
}

class MultiSelectTheme extends InheritedWidget {
  final MultiSelectThemeData data;

  const MultiSelectTheme({super.key, required this.data, required super.child});

  static MultiSelectThemeData? maybeOf(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<MultiSelectTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class MultiSelect<I, T extends MultiSelectItem<I>> extends StatefulWidget {
  final List<T> initialValue;
  final List<T> items;
  final void Function(List<I> selected) onChanged;

  const MultiSelect({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialValue = const [],
  });

  @override
  State<MultiSelect<I, T>> createState() => _MultiSelectState<I, T>();

  static Future<List<I>?> dialog<I, T extends MultiSelectItem<I>>({
    required BuildContext context,
    required List<T> items,
    List<T> initialValue = const [],
    Widget? title,
    Widget ok = const Text('Ok'),
    Widget cancel = const Text('Cancel'),
    MultiSelectThemeData? multiSelectThemeData,
  }) async {
    var selected = [...initialValue.map((e) => e.value)];

    return await showDialog<List<I>?>(
      context: context,
      builder: (context) {
        return MultiSelectTheme(
          data: multiSelectThemeData ?? const MultiSelectThemeData(),
          child: AlertDialog(
            title: title,
            content: MultiSelect<I, T>(
              items: items,
              initialValue: initialValue,
              onChanged: (value) {
                selected = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: cancel,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, selected);
                },
                child: ok,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MultiSelectState<I, T extends MultiSelectItem<I>>
    extends State<MultiSelect<I, T>> {
  final List<I> _selectedItems = [];

  @override
  void initState() {
    _selectedItems.addAll(widget.initialValue.map((e) => e.value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        MultiSelectTheme.maybeOf(context) ?? const MultiSelectThemeData();

    return ConstrainedBox(
      constraints: theme.constraints,
      child: Wrap(
        children: widget.items.map((item) {
          return ChipTheme(
            data: item.chipThemeData,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: MyChoiceChip(
                label: Text(
                  item.text,
                  style: TextStyle(
                    color: item.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                selected: _selectedItems.contains(item.value),
                onSelected: (value) {
                  if (_selectedItems.contains(item.value)) {
                    setState(() {
                      _selectedItems.remove(item.value);
                    });
                  } else {
                    setState(() {
                      _selectedItems.add(item.value);
                    });
                  }
                  widget.onChanged([..._selectedItems]);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MyChoiceChip extends StatelessWidget {
  final Widget label;
  final bool selected;
  final void Function(bool)? onSelected;

  const MyChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected?.call(!selected);
      },
      child: Chip(
        avatar: selected
            ? const Icon(
                Icons.check,
                color: Colors.white70,
                size: 14,
              )
            : null,
        label: label,
      ),
    );
  }
}
