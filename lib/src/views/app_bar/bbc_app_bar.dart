import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';

AppBar buildAppBar({
  String title,
  bool showBackButton = false,
  Function backOnPressed,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      title,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontFamily: GoloFont,
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: GoloColors.secondary1,
      ),
    ),
    leading: showBackButton
        ? IconButton(
            icon: Icon(
              DenLineIcons.angle_left,
              color: Colors.black,
            ),
            onPressed: backOnPressed,
          )
        : null,
  );
}
