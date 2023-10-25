import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_analytics/providers/user.dart';
import '../../components/bottom_navigation_bar.dart';
import 'dart:io' show Platform;

class BottomBar extends StatelessWidget{
  final Function(int, {bool animated}) changePage;
  final int currentPage;
  const BottomBar({Key key, @required this.changePage, this.currentPage = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "bottom-bar",
      child: AdaptiveBottomNavigationBar(
        tabs: [
          const BottomNavigationBarItem(
            icon: Icon(
                CupertinoIcons.hand_thumbsup,
                size: 26
            ),
            activeIcon: Icon(
                CupertinoIcons.hand_thumbsup_fill,
                size: 26),
            label: "Prediction",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
                CupertinoIcons.at,
                size: 26
            ),
            activeIcon: Icon(
                CupertinoIcons.at,
                size: 26),
            label: "Instagram",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Platform.isIOS ? CupertinoIcons.person_circle : Icons.person_outline,
                  size: 26
              ),
              activeIcon: Icon(
                  Platform.isIOS ? CupertinoIcons.person_circle_fill : Icons.person,
                  size: 26
              ),
              label: loggedUser!=null ? "Profile" : "Settings"
          ),
        ],
        currentPage: currentPage,
        changePage: changePage,
      ),
    );
  }

}