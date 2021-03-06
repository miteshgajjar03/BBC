import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';

final googleApiKey = 'AIzaSyCrGRnzKChN_9d9sENM1dnVVIwDTf8wptk';

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

//
// ImagePicker ActionSheet
//
enum PhotoPickerOption { camera, photoLibrary, cancel }
showImagePickerActionSheet({
  @required BuildContext context,
  @required Function(PhotoPickerOption) selectedOption,
}) {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'Camera',
                style: TextStyle(
                  fontFamily: GoloFont,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                selectedOption(PhotoPickerOption.camera);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Photo Library',
                style: TextStyle(
                  fontFamily: GoloFont,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                selectedOption(PhotoPickerOption.photoLibrary);
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              selectedOption(PhotoPickerOption.cancel);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  } else {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          height: 350.0,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  'Camera',
                  style: TextStyle(
                    fontFamily: GoloFont,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  selectedOption(PhotoPickerOption.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    fontFamily: GoloFont,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  selectedOption(PhotoPickerOption.photoLibrary);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

//
// GET MAP IMAGE FROM LAT LONG
//
String getMapURLFrom({
  @required latitude,
  @required longitude,
  int zoom = 15,
}) {
  if (latitude == null || longitude == null) {
    return '';
  }
  return "http://maps.google.com/maps/api/staticmap?center=$latitude,$longitude&zoom=$zoom&size=600x400&sensor=false&markers=color:red%7Clabel:%7C$latitude,$longitude&key=$googleApiKey";
}

Widget getCenterInfoWidget({
  @required String message,
}) {
  return Center(
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22.0,
        fontFamily: GoloFont,
      ),
    ),
  );
}

//
// GET PROGRESS INDICAOR
//
ProgressDialog getProgressIndicator(
    {@required BuildContext context, String loadingMessage}) {
  final progress = ProgressDialog(
    context,
    isDismissible: false,
  );
  progress.style(
    message: loadingMessage,
  );
  return progress;
}
