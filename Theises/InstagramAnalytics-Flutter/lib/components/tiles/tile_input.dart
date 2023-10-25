import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TileInput extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final Function onSubmitted;
  final double borderRadius;
  final double height;
  final bool autofocus;
  final bool multiline;
  final TextCapitalization textCapitalization;
  final bool autoselect;
  final List<TextInputFormatter> inputFormatters;
  TextEditingController providedController;
  FocusNode focusNode;
  String value;

  TileInput(
      {Key key, this.text,
      this.icon,
      this.obscureText = false,
      this.keyboardType,
      this.onChanged,
      this.onSubmitted,
      this.borderRadius,
      this.height,
      this.autofocus = false,
      this.focusNode,
      this.value,
      this.providedController,
      this.multiline = false,
      this.textCapitalization = TextCapitalization.none,
      this.inputFormatters,
      this.autoselect = false}) : super(key: key);

  @override
  State<TileInput> createState() => TileInputState();
}

class TileInputState extends State<TileInput> {
  TextEditingController controller;

  @override
  void initState() {
    if (widget.providedController == null) {
      controller = TextEditingController(text: widget.value);
    } else {
      widget.providedController.text = widget.value;
      controller = widget.providedController;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _inputSection = CupertinoTextField(
      textAlign: widget.multiline ? TextAlign.start : TextAlign.end,
      minLines: widget.multiline ? 1 : 1,
      maxLines: widget.multiline ? 4 : 1,
      controller: controller,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      textCapitalization: widget.textCapitalization,
      onSubmitted: (value) {
        if (widget.onSubmitted != null) widget.onSubmitted();
      },
      onTap: () {
        if (widget.autoselect) {
          controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
              isDirectional: true);
        }
      },
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.onSubmitted == null
          ? TextInputAction.next
          : TextInputAction.done,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: (value) {
        if (widget.onChanged != null) widget.onChanged(value);
      },
      style: TextStyle(
          fontSize: 14,
          fontFamily: Theme.of(context).textTheme.subtitle2.fontFamily,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.subtitle2.color),
      clearButtonMode: widget.multiline
          ? OverlayVisibilityMode.never
          : OverlayVisibilityMode.editing,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
    );

    Widget content = Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Icon(
                  widget.icon,
                  color: Theme.of(context).primaryColorLight,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        Text(
          widget.text,
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColorLight),
        ),
        !widget.multiline
            ? Expanded(
                child: _inputSection,
                flex: 5,
              )
            : Container(),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(BORDER_RADIUS),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            content,
            Padding(
              padding: const EdgeInsets.only(left: 33),
              child: widget.multiline ? _inputSection : Container(),
            )
          ],
        ),
      ),
    );
  }
}
