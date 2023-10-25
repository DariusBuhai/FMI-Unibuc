import 'package:flutter/material.dart';

class ColorfulIcon extends StatelessWidget{

  final IconData icon;
  final Color color;

  const ColorfulIcon({Key key, this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 60,
          height: 60,
          color: color.withOpacity(.1),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
      ),
    );
  }

}