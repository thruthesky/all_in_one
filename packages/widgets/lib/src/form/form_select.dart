import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// Select Box
///
/// It's like the selection box of HTML FORM.
/// [defaultValue] is the default value when there is no selected value.
///   It is empty string by default. So, if the options has empty value(key),
///   then it will produce an assertion of duplicated key.
/// [defaultLabel] is the default label of default value.
/// [selectedValue] is the selected value to set on init.
/// [options] is a map where the key is value and the value of the map is label.
/// example
/// ```dart
/// FormSelect(
///   options: widget.forumController.state.widget.editableCategories!,
///   defaultValue: '',
/// selectedValue: widget.post.categoryId,
/// defaultLabel: 'Select category',
/// onChanged: (categoryId) => setState(() => widget.post.categoryId = categoryId),
/// ),
/// ```
class FormSelect extends StatefulWidget {
  const FormSelect({
    this.defaultValue = '',
    this.defaultLabel = 'Select option',
    required this.options,
    required this.onChanged,
    this.selectedValue,
    Key? key,
  }) : super(key: key);

  final Map<String, dynamic> options;
  final String defaultLabel;
  final dynamic defaultValue;
  final StringCallback onChanged;
  final dynamic selectedValue;

  @override
  _FormSelectState createState() => _FormSelectState();
}

class _FormSelectState extends State<FormSelect> {
  dynamic v;

  @override
  void initState() {
    super.initState();
    if (widget.selectedValue != null) {
      v = widget.selectedValue;

      /// If defaultValue is '' and selectedValue is '', then do nothing.
      /// This means, that there is no selectedValue.
      if (widget.defaultValue == widget.selectedValue) {
        ///
      }

      /// If the selectedValue is not in options, add one.
      else if (widget.options.entries.where((e) => e.key == v).length != 1) {
        widget.options[v] = v;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      value: v ?? widget.defaultValue,
      items: [
        DropdownMenuItem(
          child: Text(widget.defaultLabel),
          value: widget.defaultValue,
        ),
        ...widget.options.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList()
      ],
      onChanged: (dynamic value) {
        setState(() {
          v = value;
        });
        widget.onChanged(v);
      },
    );
  }
}
