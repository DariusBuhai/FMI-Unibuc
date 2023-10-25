import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBackButton extends StatelessWidget {
  // true if the page is a cupertino full screen dialog (mrt page)
  // so the chvron points downwards, and text is "done" instead of "back"
  final bool fullScreen;
  final bool x;
  const AppBackButton({this.fullScreen = false, this.x = false});

  @override
  Widget build(BuildContext context) {
    final IconData icon = x
        ? FontAwesomeIcons.times
        : (fullScreen ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft);
    final String text = x ? "" : (fullScreen ? "done" : "back");

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(1000.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(1000.0)),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Padding(
                // if has the x, not padding
                padding: x ? const EdgeInsets.all(0.0) : const EdgeInsets.only(right: 10.0),
                child: Icon(
                    icon,
                    size: 14,
                    color: Colors.white,
                ),
              ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                ),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}
