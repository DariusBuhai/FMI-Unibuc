import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AdaptiveTabBar extends StatefulWidget {
  final int currentTab;
  final Function(int) onChange;
  final List<String> tabs;

  const AdaptiveTabBar(
      {Key key, @required this.currentTab, this.onChange, @required this.tabs})
      : super(key: key);

  @override
  State<AdaptiveTabBar> createState() => _AdaptiveSelectSegmentState();
}

class _AdaptiveSelectSegmentState extends State<AdaptiveTabBar>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    if (Platform.isAndroid) {
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
      );
      _tabController.addListener(_tabListener);
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    super.dispose();
  }

  void _tabListener() {
    if(!_tabController.indexIsChanging) {
      widget.onChange(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      _tabController.index = widget.currentTab;

      return SizedBox(
        height: 60,
        child: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColorLight,
          unselectedLabelColor: Theme.of(context).primaryColorLight,
          tabs: List.generate(widget.tabs.length, (index) {
            return Tab(text: widget.tabs[index]);
          }),
          controller: _tabController,
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: HORIZONTAL_PADDING, vertical: 10),
        child: SizedBox(
          width: 1000,
          child: CupertinoSlidingSegmentedControl(
              children: List.generate(widget.tabs.length, (index) {
                return Text(
                  widget.tabs[index],
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                );
              }).asMap(),
              groupValue: widget.currentTab,
              onValueChanged: widget.onChange),
        ));
  }
}
