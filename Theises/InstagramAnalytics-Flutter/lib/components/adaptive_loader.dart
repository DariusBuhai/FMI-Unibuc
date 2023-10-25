import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:io" show Platform;

class AdaptiveLoader extends StatelessWidget{

  final double radius;

  const AdaptiveLoader({Key key, this.radius = 15}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){
      return CupertinoActivityIndicator(
        radius: radius,
      );
    }
    return Center(
      child: SizedBox(
        height: 2 * radius,
        width: 2 * radius,
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }

}