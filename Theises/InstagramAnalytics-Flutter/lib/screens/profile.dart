import 'package:instagram_analytics/screens/auth/auth.dart';
import 'package:instagram_analytics/components/page_templates/blank_page_template.dart';
import 'package:instagram_analytics/components/alert.dart';
import 'package:instagram_analytics/components/terms_conditions.dart';
import 'package:instagram_analytics/components/tiles/tile_button.dart';
import 'package:instagram_analytics/components/tiles/tile_text.dart';
import 'package:instagram_analytics/providers/user.dart';
import 'package:instagram_analytics/screens/profile_settings.dart';
import 'package:instagram_analytics/tabbed_app.dart';
import 'package:instagram_analytics/utils/route.dart';
import 'package:instagram_analytics/utils/settings.dart';
import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'change_password.dart';

class ProfileScreen extends StatelessWidget {
  final Function(int index, {bool animated}) changePage;
  const ProfileScreen({Key key, this.changePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlankPageTemplate(
      onRefresh: _onRefresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZONTAL_PADDING,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(loggedUser!=null)
              Consumer<User>(
                builder: (_, __, ___) =>  _UserName(),
              ),
            if (loggedUser != null) const SizedBox(height: 30),
            const TileText(text: "Account details"),
            if (loggedUser != null && loggedUser.loginType == 'email')
              TileButton(
                text: "Update password",
                icon: CupertinoIcons.lock,
                onTap: () {
                  Routing.openAnimatedRoute(context, const ChangePasswordPage());
                },
              ),
            if (loggedUser != null)
              TileButton(
                  text: "Instagram account",
                  icon: CupertinoIcons.at_badge_minus,
                  leading: Container(),
                  onTap: () => changePage(1)
              ),
            if (loggedUser != null)
              TileButton(
                text: "Profile Settings",
                icon: CupertinoIcons.rectangle_stack_person_crop,
                onTap: () async {
                  Routing.openAnimatedRoute(context, const UserDetailsScreen());
                },
                leading: Container(),
              ),
            if (loggedUser == null)
              TileButton(
                text: "Sign in or create an account",
                icon: CupertinoIcons.square_arrow_right,
                onTap: () async {
                  Routing.openReplacementRoute(context, const AuthPage());
                },
                leading: Container(),
              ),
            if (loggedUser != null)
              TileButton(
                text: "Sign out",
                icon: CupertinoIcons.square_arrow_left,
                onTap: () async {
                  await loggedUser.logOut();
                  Routing.openReplacementRoute(context, const TabbedApp(initialPage: 2));
                },
                leading: Container(),
              ),
            if (loggedUser != null)
              TileButton(
                text: "Delete account",
                icon: CupertinoIcons.trash,
                leading: Container(),
                onTap: () {
                  alertDialog(context, alertId: "delete_account",
                      onConfirmed: () async {
                        await loggedUser.delete();
                        Routing.openReplacementRoute(context, const TabbedApp(initialPage: 2));
                      });
                },
              ),
            const TileText(text: "Settings"),
            TileButton(
              text: "Dark mode",
              icon: CupertinoIcons.moon_stars,
              leading: Switch.adaptive(
                  activeColor: Theme.of(context).primaryColor,
                  value: Provider.of<Settings>(context).darkMode,
                  onChanged: (value) {
                    Provider.of<Settings>(context, listen: false).darkMode =
                        value;
                    Provider.of<Settings>(context, listen: false)
                        .switchAutomatically = false;
                  }),
            ),
            TileButton(
              text: "Switch automatically",
              icon: CupertinoIcons.brightness_solid,
              leading: Switch.adaptive(
                  value: Provider.of<Settings>(context).switchAutomatically,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    Provider.of<Settings>(context, listen: false)
                        .switchAutomatically = value;
                  }),
            ),
            const TileText(text: "More"),
            TileButton(
              text: "Rate app",
              icon: CupertinoIcons.star_circle,
              onTap: () async {
                if (await InAppReview.instance.isAvailable()) {
                  InAppReview.instance.requestReview();
                }
              },
              leading: Container(),
            ),
            const SizedBox(height: 10),
            TermsConditions(leadingText: ""),
            const SizedBox(height: 120)
          ],
        ),
      ),
    );
  }

  void _onRefresh() async {
    HapticFeedback.mediumImpact();
    if(loggedUser!=null){
      await loggedUser.reloadUser();
    }
  }

}

class _UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(loggedUser.username ?? '',
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 40)),
        const SizedBox(height: 5),
        Text(
          loggedUser.email,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12),
        )
      ],
    );
  }
}
