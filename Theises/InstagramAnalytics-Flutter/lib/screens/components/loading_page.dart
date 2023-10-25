import 'package:flutter/material.dart';

import '../../components/adaptive_loader.dart';

class LoadingPage extends StatelessWidget{

  final String message;

  const LoadingPage({Key key, this.message = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 100,
                  child: AdaptiveLoader(
                    radius: 15,
                  ),
                ),
                Text(
                  "Loading page ...",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}