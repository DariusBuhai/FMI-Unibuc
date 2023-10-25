import 'package:flutter/material.dart';
import 'package:instagram_analytics/utils/theme.dart';

class TileInfo extends StatelessWidget {
  final String text;
  final String value;
  final IconData icon;
  final Widget child;
  final Color iconColor;
  const TileInfo({
    this.text,
    this.value,
    this.icon,
    this.child,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    // if there is no icon, show text only,
    // otherwise show row
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
                  icon,
                  color: iconColor ?? Theme.of(context).primaryColorLight,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  text,
                  style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorLight)
              ),
              child ?? Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: Theme.of(context).textTheme.subtitle2.fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.subtitle2.color
                  ),
                )
              )
            ],
          ),
          flex: 5,
        ),
        const SizedBox(width: 7)
      ],
    );

    return Container(
      margin: const EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(BORDER_RADIUS),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            content,
          ],
        ),
      ),
    );
  }
}
