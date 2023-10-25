

import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class AdaptiveBottomNavigationBar extends StatelessWidget{
  final List<BottomNavigationBarItem> tabs;
  final int currentPage;
  final Function(int, {bool animated}) changePage;

  const AdaptiveBottomNavigationBar({Key key, @required this.tabs, @required this.currentPage, @required this.changePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){
      return SizedBox(
        height: 90,
        child: CupertinoTabBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.7),
          items: tabs,
          activeColor: Theme.of(context).textTheme.subtitle2.color,
          onTap: (index){
            changePage(index, animated: false);
          },
          currentIndex: currentPage,
          iconSize: 27,
        ),
      );
    }
    return BottomNavigationBar(
      unselectedFontSize: 10,
      selectedFontSize: 10,
      selectedItemColor: Theme.of(context).textTheme.subtitle2.color,
      unselectedItemColor: Theme.of(context).textTheme.subtitle2.color,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      items: tabs,
      currentIndex: currentPage,
      onTap: (index){
        changePage(index, animated: false);
      },
    );
  }

}
