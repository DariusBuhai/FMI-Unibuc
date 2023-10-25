import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/fields/input_field.dart';
import 'package:instagram_analytics/components/tiles/tile_info.dart';
import 'package:instagram_analytics/components/tiles/tile_text.dart';
import 'package:instagram_analytics/providers/instagram_account.dart';
import 'package:instagram_analytics/utils/network.dart';
import 'package:provider/provider.dart';
import '../components/page_templates/page_template.dart';
import '../providers/user.dart';
import '../utils/route.dart';
import 'auth/auth.dart';

class InstagramAccountScreen extends StatefulWidget {
  const InstagramAccountScreen({Key key}) : super(key: key);


  @override
  InstagramAccountScreenState createState() => InstagramAccountScreenState();
}

class InstagramAccountScreenState extends State<InstagramAccountScreen> {

  bool loadingUsername = false;

  @override
  Widget build(BuildContext context) {
    if (loggedUser != null) {
      return PageTemplate(
        title: "Instagram Account",
        previousPageTitle: "Predict posts",
        child: Consumer<InstagramAccount>(
          builder: (_, __, ___) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 10, bottom: 100),
              child: Center(
                child: Column(
                  children: [
                    const TileText(text: "Instagram account: "),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            icon: CupertinoIcons.at,
                            color: Theme.of(context).cardColor,
                            text: "username",
                            value: Provider.of<InstagramAccount>(context).username,
                            onChanged: (val){
                              Provider.of<InstagramAccount>(context, listen: false).username = val;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 55,
                          height: 55,
                          child: AdaptiveButton(
                            textColor: Colors.white,
                            color: Provider.of<InstagramAccount>(context).connected ? Colors.blue : Colors.deepOrangeAccent,
                            iconData: Provider.of<InstagramAccount>(context).connected ? CupertinoIcons.refresh : CupertinoIcons.add,
                            loading: loadingUsername,
                            onTap: () async{
                              setState((){loadingUsername=true;});
                              var response = await Provider.of<InstagramAccount>(context, listen: false).loadUser();
                              if(response.runtimeType == NetworkError){
                                response.showAlert(context);
                              }
                              setState((){loadingUsername=false;});
                            },
                          ),
                        )
                      ],
                    ),
                    if(Provider.of<InstagramAccount>(context).connected)
                      const TileText(text: "Account statistics: "),
                    if(Provider.of<InstagramAccount>(context).connected)
                      const SizedBox(height: 10),
                    if(Provider.of<InstagramAccount>(context).connected)
                      TileInfo(
                        text: "Friends",
                        value: "${Provider.of<InstagramAccount>(context).followers} followers | ${Provider.of<InstagramAccount>(context).following} following",
                        icon: CupertinoIcons.person_3_fill,
                      ),
                    if(Provider.of<InstagramAccount>(context).connected)
                      TileInfo(
                        text: "Mean likes",
                        value: "${Provider.of<InstagramAccount>(context).medianLikes} for ${Provider.of<InstagramAccount>(context).postsCount} posts",
                        icon: CupertinoIcons.hand_thumbsup,
                      ),
                  ],
                ),
              ))
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("You are not sign in",
                style: Theme.of(context).textTheme.headline2),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  "In order to connect your instagram account, sign in our app.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .color
                          .withOpacity(.4))),
            ),
            const SizedBox(height: 30),
            AdaptiveButton(
              text: "Sign in to continue",
              iconData: CupertinoIcons.square_arrow_right,
              textColor: Colors.white,
              onTap: () async {
                Routing.openReplacementRoute(context, const AuthPage());
              },
            )
          ],
        ),
      ),
    );
  }
}
