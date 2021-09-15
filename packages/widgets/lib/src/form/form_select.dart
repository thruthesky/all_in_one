import 'package:flutter/material.dart';

typedef StringCallback = Function(String);

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
