import 'dart:async';

import 'package:instagram_analytics/screens/auth/reset_password.dart';
import 'package:instagram_analytics/components/terms_conditions.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/tabbed_app.dart';
import 'package:instagram_analytics/utils/functions.dart';
import 'package:instagram_analytics/utils/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_analytics/providers/user.dart';
import 'package:instagram_analytics/utils/route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';
import 'dart:io' show Platform;

class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    if (await User.isLoggedIn(context)) {
      Routing.openReplacementRoute(context, const TabbedApp(initialPage: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child:  AdaptiveIconButton(
            icon: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.black, size: 35,),
            onPressed: (){
              Routing.openReplacementRoute(context, const TabbedApp(initialPage: 2));
            },
          )
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: _authSection(context),
              )
            ]),
      ),
    );
  }

  Widget _authSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const Text(
              "Sign in",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 40),
          AdaptiveButton(
            text: "Sign in by email",
            iconData: CupertinoIcons.mail_solid,
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onTap: () {
              Routing.openAnimatedRoute(context, LoginPage());
            },
          ),
          const SizedBox(height: 20),
          AdaptiveButton(
            iconData: Icons.facebook,
            color: Colors.white,
            textColor: CupertinoColors.activeBlue,
            text: "Sign in with facebook",
            onTap: () async {
              toggleAdaptiveOverlayLoader(context);
              dynamic resp;
              try {
                resp = await User.performFacebookAuth(context);
              } catch (_) {}
              toggleAdaptiveOverlayLoader(context, hide: true);
              if (resp == true) {
                Routing.openReplacementRoute(context, const TabbedApp());
              }
              if (resp.runtimeType == NetworkError || resp.runtimeType == NetworkSuccess){
                resp.showAlert(context);
              }
            },
          ),
          const SizedBox(height: 20),
          if (Platform.isIOS || Platform.isMacOS)
            AdaptiveButton(
              iconData: FontAwesomeIcons.apple,
              color: Colors.grey[900],
              textColor: Colors.white,
              text: "Sign in with apple",
              onTap: () async {
                toggleAdaptiveOverlayLoader(context);
                dynamic resp;
                try {
                  resp = await User.performAppleAuth(context);
                } catch (_) {}
                toggleAdaptiveOverlayLoader(context, hide: true);
                if (resp == true) {
                  Routing.openReplacementRoute(context, const TabbedApp());
                }
                if (resp.runtimeType == NetworkError ||
                    resp.runtimeType == NetworkSuccess) {
                  resp.showAlert(context);
                }
              },
            ),
          if (Platform.isIOS || Platform.isMacOS)
            const SizedBox(
              height: 20,
            ),
          const SizedBox(height: 5),
          CupertinoButton(
              onPressed: () {
                Routing.openAnimatedRoute(context, ResetPasswordPage());
              },
              alignment: Alignment.center,
              child: Text(
                "Forgot password?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          const SizedBox(height: 20),
          TermsConditions(),
        ],
      ),
    );
  }
}
