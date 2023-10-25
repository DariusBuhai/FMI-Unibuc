import 'package:flutter/material.dart';

class TileText extends StatelessWidget {
  final String text;
  final IconData iconData;
  final EdgeInsets padding;

  const TileText({this.text, this.iconData, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(
            top: 20,
            bottom: 7,
            right: 5
        ),
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline3.fontFamily,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColorLight
              ),
              textAlign: TextAlign.start,
            ),
            Icon(
                iconData,
                size: Theme.of(context).textTheme.headline5.fontSize / 1.2,
                color: Theme.of(context).primaryColorLight
            )
          ],
        ),
      )
    );
  }
}
