import 'package:flutter/material.dart';

import '../adaptive_loader.dart';
import 'dart:io' show Platform;

class AdaptiveTextButton extends StatelessWidget {
  final String text;
  final Widget leading;
  final Function onPressed;
  final double fontSize;
  Color textColor;

  AdaptiveTextButton(
      {Key key, @required this.onPressed,
        this.text = "",
        this.leading,
        this.fontSize = 18, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textColor ??= Theme.of(context).primaryColor;
    if (Platform.isIOS) {
      if (leading != null) {
        return TextButton(
          child: Row(
            children: [
              Text(text, style: TextStyle(color:textColor )),
              const SizedBox(width: 10),
              leading
            ],
          ),
          onPressed: onPressed,
        );
      }
      return TextButton(
        child: Text(text, style: TextStyle(color:textColor )),
        onPressed: onPressed,
      );
    }
    if (leading != null) {
      return TextButton(
        child: Row(
          children: [Text(text, style: TextStyle(color: textColor),), const SizedBox(width: 10), leading],
        ),
        onPressed: onPressed,
      );
    }
    return TextButton(child: Text(text, style: TextStyle(color: textColor),), onPressed: onPressed);
  }
}

class AdaptiveIconButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;

  const AdaptiveIconButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return IconButton(
        icon: icon,
        onPressed: onPressed,
        color: Theme.of(context).primaryColor,
        splashColor: Colors.transparent,
      );
    }
    return IconButton(icon: icon, onPressed: onPressed);
  }
}

class AdaptiveButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  Color textColor;
  Color color;
  Color borderColor;
  final double height;
  final Function onTap;
  final double borderRadius;
  final bool elevated;
  final bool loading;

  AdaptiveButton(
      {Key key, this.iconData,
        this.text = "",
        this.color,
        this.borderColor,
        this.onTap,
        this.height = 48,
        this.borderRadius = 10,
        this.elevated = false,
        this.textColor,
        this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    color = color ?? Theme.of(context).primaryColor;
    borderColor = borderColor ?? color;
    textColor = textColor ?? Theme.of(context).primaryColor;

    if (Platform.isIOS) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor),
            color: color,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: color,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (loading)
                  Padding(
                    padding: EdgeInsets.only(right: text == "" ? 0.0 : 13.0),
                    child: const AdaptiveLoader(
                      radius: 10,
                    ),
                  ),
                if (!(iconData == null) && !loading)
                  Padding(
                    padding: EdgeInsets.only(right: text == "" ? 0.0 : 13.0),
                    child: Icon(
                      iconData,
                      color: textColor,
                      size: Theme.of(context).textTheme.button.fontSize + 5,
                    ),
                  ),
                Text(
                  text,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.button.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
            onPressed: () {
              if (onTap != null) onTap();
            },
          ));
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
        splashColor: color.withOpacity(0.3),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
            boxShadow: elevated
                ? [
              BoxShadow(
                  color: Theme.of(context)
                      .primaryColorLight
                      .withOpacity(.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ]
                : [],
            border: Border.all(
                width: 0.0, color: borderColor.withOpacity(0.9)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!(iconData == null))
                  Padding(
                    padding: EdgeInsets.only(right: text == "" ? 0.0 : 13.0),
                    child: Icon(
                      iconData,
                      color: textColor,
                      size: Theme.of(context).textTheme.button.fontSize + 5,
                    ),
                  ),
                Text(
                  text,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.button.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (onTap != null) onTap();
        },
      ),
    );
  }
}
