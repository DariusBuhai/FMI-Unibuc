import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class InputField extends StatefulWidget{
  final String text;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  TextEditingController controller;
  final Function(String) onChanged;
  final Function() onAutoSave;
  final Function onSubmitted;
  final double borderRadius;
  final double height;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final bool disabled;
  final int maxLines;
  final int minLines;
  final List<String> autofillHints;
  FocusNode focusNode;
  String value;
  Color color;

  InputField({Key key,
    this.text = "",
    this.icon = Icons.search,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onAutoSave,
    this.borderRadius = 10,
    this.height = 50,
    this.autofocus = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.value,
    this.maxLines=1,
    this.minLines=1,
    this.disabled = false,
    this.color, this.autofillHints
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController controller;
  Timer autosaveTimer;

  @override
  void initState() {
    if (widget.controller == null) {
      controller = TextEditingController(text: widget.value);
    } else {
      widget.controller.text = widget.value;
      controller = widget.controller;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: defaultTargetPlatform == TargetPlatform.iOS ? 3 : 0),
              child: Icon(
                widget.icon,
                color: Theme.of(context).textTheme.subtitle2.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                onFieldSubmitted: (_){
                  if(widget.onSubmitted!=null) {
                    widget.onSubmitted();
                  }
                  if(widget.onAutoSave!=null) {
                    widget.onAutoSave();
                  }
                },
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                keyboardAppearance: Theme.of(context).brightness,
                enabled: !widget.disabled,
                textInputAction: widget.keyboardType==TextInputType.multiline ? TextInputAction.newline : (widget.onSubmitted==null ? TextInputAction.next : TextInputAction.done),
                enableInteractiveSelection: true,
                enableSuggestions: true,
                obscureText: widget.obscureText,
                controller: controller,
                textCapitalization: widget.textCapitalization,
                autofocus: widget.autofocus,
                focusNode: widget.focusNode,
                onChanged: onChanged,
                autofillHints: widget.autofillHints,
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color
                ),
                textAlignVertical: TextAlignVertical.top,
                scrollPadding: EdgeInsets.zero,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: widget.text,
                  hintStyle: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).textTheme.subtitle2.color.withOpacity(.4)
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onChanged(String value){
    if(widget.onChanged!=null) {
      widget.onChanged(value);
    }
    if(autosaveTimer!=null && autosaveTimer.isActive) {
      autosaveTimer.cancel();
    }
    autosaveTimer = Timer(const Duration(milliseconds: 500), (){
      if(widget.onAutoSave!=null) {
        widget.onAutoSave();
      }
    });
  }

}