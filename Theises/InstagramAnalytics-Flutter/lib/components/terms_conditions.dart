import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/utils/route.dart';
import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget{

  String leadingText;

  TermsConditions({Key key, this.leadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    leadingText ??= "";

    return Column(
      children: [
        Builder(
          builder: (_){
            if(leadingText!="") {
              return Text(
                leadingText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              );
            }
            return Container();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveTextButton(
              fontSize: 14,
              onPressed: () {
                Routing.openUrl(
                    "https://darius.buhai.ro/terms-conditions/Terms-Conditions.pdf");
              },
              text: "Terms of Service",
            ),
            Text(
              "and",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            AdaptiveTextButton(
              fontSize: 14,
              onPressed: () {
                Routing.openUrl(
                    "https://darius.buhai.ro/terms-conditions/Privacy-Policy.pdf");
              },
              text: "Privacy Policy",
            )
          ],
        )
      ],
    );
  }

}