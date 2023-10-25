import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/page_templates/page_template.dart';
import 'package:instagram_analytics/components/fields/input_field.dart';
import 'package:instagram_analytics/components/alert.dart';
import 'package:instagram_analytics/components/tiles/tile_text.dart';
import 'package:instagram_analytics/providers/user.dart';
import 'package:instagram_analytics/utils/network.dart';
import 'package:instagram_analytics/utils/route.dart';
import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  TextEditingController _oldPasswordInput = TextEditingController(), _newPasswordInput = TextEditingController(), _repeatNewPasswordInput = TextEditingController();
  bool _savingPassword = false;

  @override
  Widget build(BuildContext context) {

    return PageTemplate(
      title: "Password",
      previousPageTitle: "Profile",
      onRefresh: (){
        setState(() {});
      },
      trailing: AdaptiveTextButton(
          onPressed: () => _updateUserPassword(),
          text: "Save"
      ),
      child: _passwordForm()
    );
  }

  Widget _passwordForm(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TileText(text: "Old password"),
          const SizedBox(height: 10),
          InputField(
              text: "Old password",
              icon: Icons.lock_open,
              borderRadius: 10,
              obscureText: true,
              controller: _oldPasswordInput,
          ),
          const TileText(text: "New password"),
          const SizedBox(height: 10),
          InputField(
              text: "New password",
              icon: Icons.lock_outline,
              borderRadius: 10,
              obscureText: true,
              controller: _newPasswordInput,
          ),
          const SizedBox(height: 10),
          InputField(
              text: "Repeat new password",
              icon: Icons.lock,
              borderRadius: 10,
              controller: _repeatNewPasswordInput,
              obscureText: true,
              onSubmitted: (_){
                _updateUserPassword();
              }
          ),
          const SizedBox(height: 30),
          AdaptiveButton(
            text: "Save",
            iconData: CupertinoIcons.floppy_disk,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            elevated: false,
            loading: _savingPassword,
            onTap: (){
              _updateUserPassword();
            },
          )
        ],
      ),
    );
  }

  void _updateUserPassword() async{
    if(_oldPasswordInput.text.length < 4 || _newPasswordInput.text.length<4 || _repeatNewPasswordInput.text.length<4) {
      alertDialog(context, alertId: "invalid_password");
      return;
    }
    if(_newPasswordInput.text != _repeatNewPasswordInput.text){
      alertDialog(context, alertId: "passwords_do_not_match");
      return;
    }
    setState(() {_savingPassword = true;});
    var resp = await loggedUser.updateUserPassword(_oldPasswordInput.text, _newPasswordInput.text);
    setState(() {_savingPassword = false;});
    if(resp==true) {
      _oldPasswordInput.clear();
      _newPasswordInput.clear();
      _repeatNewPasswordInput.clear();
      FocusScope.of(context).unfocus();
      Routing.closeRoute(context);
    }
    if(resp.runtimeType==NetworkError || resp.runtimeType==NetworkSuccess) {
      resp.showAlert(context);
    }
  }

}