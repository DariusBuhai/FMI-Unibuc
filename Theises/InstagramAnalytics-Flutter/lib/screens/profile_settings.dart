import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/page_templates/page_template.dart';
import 'package:instagram_analytics/components/tiles/tile_info.dart';
import 'package:instagram_analytics/components/tiles/tile_input.dart';
import 'package:instagram_analytics/components/tiles/tile_text.dart';
import 'package:instagram_analytics/providers/user.dart';
import 'package:instagram_analytics/utils/network.dart';
import 'package:instagram_analytics/utils/route.dart';
import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _savingProfile = false;

  @override
  Widget build(BuildContext context) {

    return PageTemplate(
      title: "Profile Settings",
      previousPageTitle: "Profile",
      child: _content(),
      trailing: AdaptiveTextButton(
          onPressed: () => _updateUserProfile(closeRoute: true),
          text: "Save"
      ),
    );
  }

  Widget _content(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING,
        vertical: 10
      ),
      child: Column(
        children: [
          const TileText(text: "User Details"),
          TileInput(
            text: "Username:",
            icon: CupertinoIcons.person_solid,
            value: loggedUser.username,
            textCapitalization: TextCapitalization.words,
            onChanged: (value){
              loggedUser.username = value;
            },
          ),
          TileInfo(
            text: "Email:",
            icon: CupertinoIcons.mail_solid,
            value: loggedUser.email,
          ),
          Builder(
            builder: (_){
              IconData _icon;
              Color _color;
              if(loggedUser.loginType=="facebook") {
                _icon = Icons.facebook;
                _color = CupertinoColors.activeBlue;
              } else if(loggedUser.loginType=="apple") {
                _icon = FontAwesomeIcons.apple;
                _color = Theme.of(context).primaryColorLight;
              } else {
                _icon = CupertinoIcons.envelope_open_fill;
                _color = Theme.of(context).primaryColor;
              }
              return TileInfo(
                text: "Signed in with:",
                icon: _icon,
                child: Text(
                    loggedUser.loginType,
                    style: TextStyle(
                        color: _color
                    )
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          AdaptiveButton(
            text: "Save",
            iconData: CupertinoIcons.floppy_disk,
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            elevated: false,
            onTap: () => _updateUserProfile(closeRoute: true),
            loading: _savingProfile,
          )
        ],
      ),
    );
  }

  void _updateUserProfile({bool closeRoute = false}) async{
    setState(() {_savingProfile = true;});
    var resp = await loggedUser.updateUser();
    await loggedUser.reloadUser();
    if(resp.runtimeType==NetworkError || resp.runtimeType==NetworkSuccess) {
      resp.showAlert(context);
    } else if(resp == true && closeRoute){
      FocusScope.of(context).requestFocus(FocusNode());
      Routing.closeRoute(context);
    }
    setState(() {_savingProfile = false;});
  }

}