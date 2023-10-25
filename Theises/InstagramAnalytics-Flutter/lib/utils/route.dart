import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class Routing {
  static void openAnimatedRoute(BuildContext context, Widget page) {
    if(Platform.isIOS){
      Navigator.push(
        context,
        MaterialWithModalsPageRoute(
          maintainState: true,
          builder: (context) => page,
        ),
      );
    }else {
      Navigator.push(
        context,
        MaterialPageRoute(
          maintainState: true,
          builder: (context) => page,
        ),
      );
    }
  }

  static void openRoute(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        maintainState: true,
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  static void openFullScreenDialog(BuildContext context, Widget page, {bool replacement = false}) {
    PageRoute pageRoute;
    if(Platform.isIOS) {
      pageRoute = CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => page,
      );
    }else{
      pageRoute = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => page,
      );
    }
    if(replacement) {
      Navigator.pushReplacement(context, pageRoute);
    } else {
      Navigator.push(context, pageRoute);
    }
  }

  // no going back allowed
  static void openReplacementRoute(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: false,
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, animation1, animation2) => page,
      ),
    );
  }

  static void openAnimatedReplacementRoute(BuildContext context, Widget page) {
    if(Platform.isIOS){
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          maintainState: true,
          builder: (context) => page,
        ),
      );
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          maintainState: true,
          builder: (context) => page,
        ),
      );
    }
  }

  static void closeRoute(BuildContext context) => Navigator.of(context).pop();

  static void openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


