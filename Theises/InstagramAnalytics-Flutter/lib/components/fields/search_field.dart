import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class SearchField extends StatelessWidget{

  String text;
  IconData icon;
  bool obscureText;
  TextInputType keyboardType;
  TextEditingController controller;
  Function(String) onChanged;
  double borderRadius;
  double height;

  SearchField({Key key,
    this.text = "",
    this.icon = CupertinoIcons.search,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.borderRadius = 10,
    this.height = 45
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    if(Platform.isIOS){
      return SizedBox(
        height: height,
        child: CupertinoSearchTextField(
          placeholder: text,
          padding: const EdgeInsets.only(
              left: 10,
              bottom: 2
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          controller: controller,
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontFamily: Theme.of(context).textTheme.subtitle1.fontFamily
          ),
          onChanged: onChanged
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Theme.of(context).primaryColorLight.withOpacity(.1)
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  spreadRadius: 3,
                  blurRadius: 10
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            enableInteractiveSelection: true,
            enableSuggestions: true,
            obscureText: obscureText,

            onSubmitted: (val){
              if(onChanged!=null) {
                onChanged(val);
              }
            },
            onChanged: (val){
              if(onChanged!=null) {
                onChanged(val);
              }
            },
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: text,
                alignLabelWithHint: true,
                hintStyle: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColorLight,
                    fontFamily: Theme.of(context).textTheme.subtitle1.fontFamily
                ),
                suffixIcon: Icon(
                  icon,
                  color: CupertinoColors.activeBlue,
                  size: 28,
                )),
          ),
        ),
      ),
    );
  }

}