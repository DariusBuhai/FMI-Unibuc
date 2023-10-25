import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../adaptive_loader.dart';

class PageTemplate extends StatelessWidget {
  final Widget child;
  final Function onRefresh;
  final String title;
  final Widget trailing;
  final String previousPageTitle;
  final bool pageLoaded;
  final bool refreshIndicator;
  final bool automaticallyImplyLeading;
  ScrollController scrollController;

  PageTemplate(
      {Key key,
      this.child,
      this.onRefresh,
      this.title = "",
      this.trailing,
      this.previousPageTitle = "",
      this.pageLoaded = true,
      this.refreshIndicator = true,
      this.scrollController,
      this.automaticallyImplyLeading = true})
      : super(key: key);

  Future<void> _onRefresh() async {
    if (onRefresh != null) await onRefresh();
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          actions: trailing != null ? [trailing] : [],
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            if (refreshIndicator) {
              return Scrollbar(
                child: RefreshIndicator(
                    onRefresh: () => _onRefresh(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                          constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 100),
                          child: Builder(
                            builder: (context) {
                              if (pageLoaded) return child;
                              return const Center(
                                  child: SizedBox(
                                width: 50,
                                child: AdaptiveLoader(
                                  radius: 15,
                                ),
                              ));
                            },
                          )),
                    )),
              );
            }
            return Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 100),
                child: Builder(
                  builder: (context) {
                    if (pageLoaded) return child;
                    return const Center(
                        child: SizedBox(
                      width: 50,
                      child: AdaptiveLoader(
                        radius: 15,
                      ),
                    ));
                  },
                ));
          },
        ),
      );
    }

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          title,
          style: TextStyle(color: Theme.of(context).textTheme.headline6.color),
        ),
        previousPageTitle: previousPageTitle,
        trailing: trailing,
        backgroundColor: Colors.transparent,
        brightness: Theme.of(context).brightness,
      ),
      body: Builder(
        builder: (context) {
          if (refreshIndicator) {
            Scrollbar(
              controller: scrollController,
              child: CustomScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
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
            );
          }
          if (pageLoaded) {
            return child;
          }
          return const Center(
            child: AdaptiveLoader(
              radius: 15,
            ),
          );
        },
      ),
    );
  }
}
