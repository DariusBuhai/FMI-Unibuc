import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TileButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;
  Color iconColor;
  List<Widget> children;
  Widget leading;
  TileButton({
    this.text,
    this.icon,
    this.onTap,
    this.children,
    this.leading,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    // if there is no icon, show text only,
    // otherwise show row
    Widget child = Row(
      children: <Widget>[
        Builder(
          builder: (_){
            if(icon!=null){
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 10
                      ),
                      child: Icon(
                        icon,
                        size: 23,
                        color: iconColor ?? Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container(
              width: 20,
            );
          },
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColorLight
            ),
          ),
          flex: 5,
        ),
        Builder(
            builder: (_){
              if(leading!=null) {
                return leading;
              }
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  CupertinoIcons.right_chevron,
                  color: Theme.of(context).textTheme.subtitle2.color.withOpacity(.6),
                  size: 20,
                )
              );
            }
        )
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(
          top: 4,
          bottom: 4,
        ),
        height: 50,
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 5
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(BORDER_RADIUS),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                child,
                if (children != null) ...[
                  const SizedBox(
                    height: 15,
                  ),
                  Wrap(
                    spacing: 20,
                    children: children,
                  )
                ],
              ],
            ),
          ),
          enableFeedback: true,
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (onTap != null) onTap();
          },
        ),
      ),
    );
  }
}
