import 'package:instagram_analytics/components/alert.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/fields/input_field.dart';
import 'package:instagram_analytics/components/terms_conditions.dart';
import 'package:instagram_analytics/components/page_templates/adaptive_app_bar.dart';
import 'package:instagram_analytics/utils/functions.dart';
import 'package:instagram_analytics/utils/network.dart';
import 'package:instagram_analytics/utils/theme.dart';
import 'package:instagram_analytics/utils/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_analytics/providers/user.dart';
import 'package:instagram_analytics/utils/route.dart';

import 'login.dart';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _passwordInput = TextEditingController(),
      _passwordAgainInput = TextEditingController(),
      _emailInput = TextEditingController();

  ResetPasswordPage({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Styles.themeData(true, context),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child: const AdaptiveAppBar(
              automaticallyImplyLeading: true,
              previousPageTitle: "Auth",
            ),
          ),
          body: Center(
              child: SingleChildScrollView(
            child: _registerSection(context),
          ))),
    );
  }

  Widget _registerSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reset\npassword",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 50),
              InputField(
                text: "Email",
                icon: CupertinoIcons.mail_solid,
                keyboardType: TextInputType.emailAddress,
                controller: _emailInput,
                color: Theme.of(context).cardColor,
                height: 50,
              ),
              const SizedBox(height: 20),
              InputField(
                text: "Password",
                icon: CupertinoIcons.lock_open_fill,
                obscureText: true,
                controller: _passwordInput,
                color: Theme.of(context).cardColor,
                height: 50,
              ),
              const SizedBox(height: 20),
              InputField(
                text: "Password again",
                icon: CupertinoIcons.lock_fill,
                obscureText: true,
                controller: _passwordAgainInput,
                color: Theme.of(context).cardColor,
                height: 50,
                onSubmitted: () {
                  _resetPasswordAction(context);
                },
              ),
              const SizedBox(height: 50),
              AdaptiveButton(
                text: "Send recover mail",
                iconData: CupertinoIcons.mail,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onTap: () {
                  _resetPasswordAction(context);
                },
              ),
              const SizedBox(height: 10),
              AdaptiveButton(
                iconData: CupertinoIcons.arrow_turn_up_left,
                color: Colors.white,
                textColor: Colors.black,
                text: "Back to login",
                onTap: () async {
                  Routing.openAnimatedReplacementRoute(context, LoginPage());
                },
              ),
              const SizedBox(height: 20),
              TermsConditions(),
            ],
          ),
        )
      ],
    );
  }

  void _resetPasswordAction(BuildContext context) async {
    if(Validators.EMAIL_VALIDATOR(_emailInput.text)!=null) {
      alertDialog(context, alertId: "invalid_username");
      return;
    }
    if(Validators.PASSWORD_VALIDATOR(_passwordInput.text)!=null){
      alertDialog(context, alertId: "invalid_password");
      return;
    }
    if (_passwordInput.text != _passwordAgainInput.text) {
      alertDialog(context, alertId: "passwords_do_not_match");
      return;
    }
    toggleAdaptiveOverlayLoader(context);
    dynamic resp;
    try{
      resp = await User.resetUserPassword(_emailInput.text, _passwordInput.text);
    }catch(_){}
    toggleAdaptiveOverlayLoader(context, hide: true);
    if (resp == true) {
      alertDialog(context,
          title: "Email sent",
          subtitle: "You will receive an email shortly with instructions");
      _emailInput.clear();
      _passwordInput.clear();
      _passwordAgainInput.clear();
    }
    if (resp.runtimeType == NetworkError || resp.runtimeType == NetworkSuccess) {
      resp.showAlert(context);
    }
  }
}
