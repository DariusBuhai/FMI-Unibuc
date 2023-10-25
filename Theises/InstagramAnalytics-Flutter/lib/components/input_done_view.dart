import 'package:flutter/material.dart';

Widget inputDoneView(BuildContext context, {Function() callback, double height}) {
  return Container(
    height: 45,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Theme.of(context).cardColor,
          width: 1.0,
        ),
      ),
    ),
    child: SafeArea(
      top: false,
      bottom: false,
      child: Container(
        color: Theme.of(context).cardColor,
        child: Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  callback();
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    color: Theme.of(context).cardColor,
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      )
    ),
  );
}