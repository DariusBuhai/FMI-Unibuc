import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double iconSize;
  final Function onTap;
  final double borderRadius;

  const CustomIconButton({this.icon, this.color, this.backgroundColor, this.iconSize = 18, this.onTap, this.borderRadius = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorLight.withOpacity(.12),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ]
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: 60,
          height: 60,
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)
            ),
          ),
          child: IconButton(
            icon: Icon(
                icon,
                color: color,
                size: iconSize
            ),
            color: color,
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}
