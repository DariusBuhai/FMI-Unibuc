import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:instagram_analytics/components/adaptive_loader.dart';
import 'dart:io' show Platform;

class BlankPageTemplate extends StatelessWidget {
  final Widget child;
  final Function onRefresh;
  final Widget trailing;
  final Widget largeTitle;
  final bool pageLoaded;

  const BlankPageTemplate(
      {Key key,
      @required this.child,
      this.onRefresh,
      this.trailing,
      this.largeTitle,
      this.pageLoaded = true})
      : super(key: key);

  Future<void> _onRefresh() async {
    if (onRefresh != null) await onRefresh();
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(onRefresh: _onRefresh),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            ),
            SliverToBoxAdapter(
              child: pageLoaded
                  ? child
                  : const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: AdaptiveLoader(
                        radius: 15,
                      )),
            )
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Scrollbar(
        child: RefreshIndicator(
            onRefresh: () => onRefresh(),
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.only(top: 50),
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100),
                  child: child,
                )
            )
        ),
      ),
    );
  }
}
