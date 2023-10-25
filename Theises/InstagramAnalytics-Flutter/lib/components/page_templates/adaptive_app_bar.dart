

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AdaptiveAppBar extends StatelessWidget{

  final String title;
  final String previousPageTitle;
  final Widget trailing;
  final Widget leading;
  final bool automaticallyImplyLeading;


  const AdaptiveAppBar({Key key, this.title = "", this.previousPageTitle = "", this.trailing, this.leading, this.automaticallyImplyLeading=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(Platform.isAndroid) {
      return AppBar(
        title: Text(
          title,
          style: TextStyle(
              color: Theme
                  .of(context)
                  .primaryColorLight
          ),
        ),
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: trailing != null ? [
        trailing
        ] : [],
        centerTitle: true,
        elevation: 0,
      );
    }

    return CupertinoNavigationBar(
      middle: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).textTheme.headline6.color
        ),
      ),
      leading: leading,
      previousPageTitle: previousPageTitle,
      trailing: trailing,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      brightness: Theme.of(context).brightness,
      border: null,
    );
  }

}