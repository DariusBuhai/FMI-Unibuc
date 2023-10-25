import 'package:flutter/material.dart';
import 'package:instagram_analytics/providers/instagram_account.dart';
import 'package:instagram_analytics/screens/instagram_account.dart';
import 'package:provider/provider.dart';
import 'package:instagram_analytics/screens/components/loading_page.dart';
import 'package:instagram_analytics/providers/user.dart';
import 'package:instagram_analytics/screens/prediction.dart';
import 'package:instagram_analytics/screens/profile.dart';
import 'screens/components/bottom_bar.dart';

class TabbedApp extends StatefulWidget {
  final int initialPage;

  const TabbedApp({Key key, this.initialPage = 0}) : super(key: key);

  @override
  TabbedAppState createState() => TabbedAppState();
}

class TabbedAppState extends State<TabbedApp>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _currentPage = 0;
  bool projectItemInitialized = false;
  bool loadingPage = true;
  bool loggedIn = false;
  List<Widget> _tabViews;
  InstagramAccount instagramAccountProvider;

  @override
  void initState() {
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage);
    _setTabViews();
    asyncInitState();
    super.initState();
  }

  Future<void> asyncInitState() async {
    instagramAccountProvider = InstagramAccount();
    loggedIn = await User.isLoggedIn(context);
    if (loggedIn) {
      try {
        await instagramAccountProvider.loadUser();
      } catch (_) {}
    }
    setState(() {
      loadingPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadingPage) {
      return const LoadingPage();
    }
    if (loggedIn) {
      return MultiProvider(
        providers: [
          ListenableProvider<User>(create: (_) => loggedUser),
          ListenableProvider<InstagramAccount>(
              create: (_) => instagramAccountProvider)
        ],
        child: ActualTabbedApp(
          pageController: _pageController,
          loggedIn: loggedIn,
          currentPage: _currentPage,
          changePage: _changePage,
          tabViews: _tabViews,
        ),
      );
    }
    return MultiProvider(
        providers: [
          ListenableProvider<InstagramAccount>(
              create: (_) => instagramAccountProvider)
        ],
        child: ActualTabbedApp(
          pageController: _pageController,
          loggedIn: loggedIn,
          currentPage: _currentPage,
          changePage: _changePage,
          tabViews: _tabViews,
        )
    );
  }

  void _changePage(int index, {bool animated = true}) {
    setState(() {
      if (animated) {
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      } else {
        _pageController.jumpToPage(index);
      }
      _currentPage = index;
    });
  }

  void _setTabViews() {
    _tabViews = [
      PredictionScreen(changePage: _changePage),
      const InstagramAccountScreen(),
      ProfileScreen(changePage: _changePage),
    ];
  }
}

class ActualTabbedApp extends StatelessWidget {
  final PageController pageController;
  final bool loggedIn;
  final int currentPage;
  final Function(int, {bool animated}) changePage;
  final List<Widget> tabViews;

  const ActualTabbedApp(
      {Key key,
      this.pageController,
      this.loggedIn,
      this.currentPage,
      this.changePage,
      this.tabViews})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: tabViews,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
              currentPage: currentPage,
              changePage: changePage,
            ),
          )
        ],
      ),
    );
  }
}
