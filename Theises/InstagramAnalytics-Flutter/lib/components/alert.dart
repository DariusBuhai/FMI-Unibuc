
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

void alertDialog(BuildContext context, {String alertId, String title, String subtitle, Function onConfirmed, Function onDismissed, bool destructive = false, String confirmText}) {

  if(title==null && subtitle==null){
    title = "Error";
    subtitle = "An error occured";
  }
  confirmText ??= "Confirm";

  List<Widget> alertActions = [
    BasicDialogAction(
      title: Text(onConfirmed==null ? "Close" : "Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        if(onDismissed!=null) {
          onDismissed();
        }
        HapticFeedback.selectionClick();
      },
    )
  ];

  if(onConfirmed!=null) {
    alertActions.add(BasicDialogAction(
      title: Text(
          confirmText,
          style: TextStyle(
            color: destructive ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue
          ),
      ),
      onPressed: () {
        onConfirmed();
        Navigator.of(context).pop();
        HapticFeedback.selectionClick();
      },
    ));
  }

  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(title),
      content:
      Text(subtitle),
      actions: alertActions
    ),
  );
}