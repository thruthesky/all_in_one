import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef VoidCallbackString = void Function(String, _InputState);

/// It is a clone of TextField.
///
/// It provides [initialValue], [debounceTime], and [showLoader], [hideLoader] over TextField.
///
///
///
/// When a [controller] is specified, [initialValue] must be null (the
/// default). If [controller] is null, then a [TextEditingController]
/// will be constructed automatically and its `text` will be initialized
/// to [initialValue] or the empty string.
class Input extends StatefulWidget {
  Input({
    required this.onChanged,
    this.controller,
    this.initialValue,
    this.debounceTime = 500,
    this.loaderTop = 14,
    this.loaderLeft = 0,
    this.loaderRight = 10,
    this.loaderBottom = 0,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.onEditingComplete,
    this.onSubmitted,
    Key? key,
  }) : super(key: key);

  final VoidCallbackString onChanged;

  final TextEditingController? controller;
  final String? initialValue;

  final double loaderTop;
  final double loaderLeft;
  final double loaderRight;
  final double loaderBottom;

  final int debounceTime;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final InputDecoration? decoration;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  PublishSubject<String> subject = PublishSubject();
  late StreamSubscription subscription;
  TextEditingController? controller;
  bool _loader = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      controller = TextEditingController(text: widget.initialValue ?? '');
    } else {
      controller = widget.controller;
    }
    // Subscribe
    subscription = subject
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .distinct((a, b) => a == b)
        .listen((value) {
      // ????????? ????????? ???????????? ??????
      widget.onChanged(value, this);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // ????????? ?????? ??? ???, subscription ??????
    subscription.cancel();
  }

  showLoader() {
    setState(() {
      _loader = true;
    });
  }

  hideLoader() {
    setState(() {
      _loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          // ????????? ?????? ?????? ?????? ?????????, subscription ?????? ??? ???????????? ??????.
          onChanged: (value) => subject.add(value),
          decoration: widget.decoration,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
        ),
        if (_loader)
          Positioned(
            child: CircularProgressIndicator.adaptive(),
            right: widget.loaderRight,
            top: widget.loaderTop,
          ),
      ],
    );
  }
}
