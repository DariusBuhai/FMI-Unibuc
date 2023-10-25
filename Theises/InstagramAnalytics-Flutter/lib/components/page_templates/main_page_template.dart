import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:instagram_analytics/components/adaptive_loader.dart';
import 'dart:io' show Platform;

class MainPageTemplate extends StatelessWidget {
  final Widget child;
  final Function onRefresh;
  final String title;
  final Widget largeTitle;
  final String previousPageTitle;
  final bool pageLoaded;
  final Function leadingAction;

  const MainPageTemplate(
      {Key key,
      this.child,
      this.onRefresh,
      this.title,
      this.largeTitle,
      this.previousPageTitle,
      this.pageLoaded = true,
      this.leadingAction})
      : super(key: key);

  Future<void> _onRefresh() async {
    if (onRefresh != null) await onRefresh();
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: Scrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverNavigationBar(
                transitionBetweenRoutes: true,
                backgroundColor: Colors.transparent,
                border: null,
                largeTitle: largeTitle ?? Text(
                        title,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontFamily: GoogleFonts.poppins().fontFamily
                        ),
                      ),
                previousPageTitle: previousPageTitle,
                brightness: Theme.of(context).brightness,
                automaticallyImplyLeading: previousPageTitle != null,
              ),
              CupertinoSliverRefreshControl(onRefresh: _onRefresh),
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
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25, color: Colors.white),
        ),
        actions: const [

        ],
      ),
      body: Scrollbar(
        child: RefreshIndicator(
            onRefresh: () => onRefresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 100),
                child: child,
              ),
            )),
      ),
    );
  }
}
