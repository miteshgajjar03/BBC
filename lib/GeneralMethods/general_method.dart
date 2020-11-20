import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showConfirmationAlert({
  @required BuildContext context,
  String title,
  String message,
  String cancelButtonTitle,
  String actionButtonTitle,
  Function cancelAction,
  Function confirmAction,
}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: Text(
            title != null ? title : 'Message',
          ),
          content: Text(message != null ? message : ''),
          actions: <Widget>[
            if (cancelButtonTitle != null)
              CupertinoDialogAction(
                child: Text(
                  cancelButtonTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  cancelAction();
                },
              ),
            if (actionButtonTitle != null)
              CupertinoDialogAction(
                child: Text(
                  actionButtonTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  confirmAction();
                },
              ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title != null ? title : 'Message',
        ),
        content: Text(message != null ? message : ''),
        actions: <Widget>[
          if (cancelButtonTitle != null)
            FlatButton(
              child: Text(
                cancelButtonTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                cancelAction();
              },
            ),
          if (actionButtonTitle != null)
            FlatButton(
              child: Text(
                actionButtonTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                confirmAction();
              },
            ),
        ],
      ),
    );
  }
}

//
// Hide Keyboard
//
hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}

//
// Snackbar
//
showSnackBar(
  String message,
  BuildContext buildContext,
) {
  Scaffold.of(buildContext).hideCurrentSnackBar();
  Scaffold.of(buildContext).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

//
// Email Validation
//
bool isValidEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(em);
}
