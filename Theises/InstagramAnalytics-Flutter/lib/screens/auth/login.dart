import 'package:instagram_analytics/screens/auth/register.dart';
import 'package:instagram_analytics/screens/auth/reset_password.dart';
import 'package:instagram_analytics/components/alert.dart';
import 'package:instagram_analytics/components/fields/input_field.dart';
import 'package:instagram_analytics/components/terms_conditions.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/page_templates/adaptive_app_bar.dart';
import 'package:instagram_analytics/tabbed_app.dart';
import 'package:instagram_analytics/utils/functions.dart';
import 'package:instagram_analytics/utils/network.dart';
import 'package:instagram_analytics/utils/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_analytics/providers/user.dart';
import 'package:instagram_analytics/utils/route.dart';

class LoginPage extends StatelessWidget {

  String _password = "", _username = "";

  LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: const AdaptiveAppBar(
          automaticallyImplyLeading: true,
          previousPageTitle: "Auth",
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: _loginSection(context),
          )
      ),
    );
  }

  Widget _loginSection(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 30
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Sign in \nby email",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 50),
          InputField(
            text: "Username",
            icon: CupertinoIcons.person_fill,
            keyboardType: TextInputType.emailAddress,
            color: Theme.of(context).cardColor,
            onChanged: (val){
              _username = val;
            },
            height: 50,
          ),
          const SizedBox(height: 20),
          InputField(
            text: "Password",
            icon: CupertinoIcons.lock_fill,
            obscureText: true,
            height: 50,
            color: Theme.of(context).cardColor,
            onChanged: (val){
              _password = val;
            },
            onSubmitted: (){
              _loginAction(context);
            },
          ),
          const SizedBox(height: 50),
          AdaptiveButton(
            text: "Login",
            iconData: CupertinoIcons.square_arrow_right,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onTap: (){
              _loginAction(context);
            },
          ),
          const SizedBox(height: 10),
          AdaptiveButton(
            iconData: CupertinoIcons.person_add_solid,
            color: Colors.white,
            textColor: Colors.black,
            text: "Create an account",
            onTap: (){
              Routing.openAnimatedReplacementRoute(context, RegisterPage());
            },
          ),
          const SizedBox(height: 5),
          CupertinoButton(
              onPressed: (){
                Routing.openAnimatedReplacementRoute(context, ResetPasswordPage());
              },
              alignment: Alignment.center,
              child: Text(
                "Forgot password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor
                ),
              )
          ),
          const SizedBox(height: 20),
          TermsConditions(),
        ],
      ),
    );
  }

  void _loginAction(BuildContext context) async{
    if(Validators.EMAIL_VALIDATOR(_username)!=null) {
      alertDialog(context, alertId: "invalid_username");
      return;
    }
    if(_password.length<4){
      alertDialog(context, alertId: "invalid_password");
      return;
    }
    toggleAdaptiveOverlayLoader(context);
    dynamic resp;
    try{
      resp = await User.performLogin(_username,_password, context);
    }catch(e){}
    toggleAdaptiveOverlayLoader(context, hide: true);
    if(resp.runtimeType==NetworkError) {
      resp.showAlert(context);
    }
    if(resp==true) {
      Routing.closeRoute(context);
      Routing.openReplacementRoute(context, const TabbedApp());
    }
  }
}