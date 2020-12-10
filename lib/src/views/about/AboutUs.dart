import 'package:flutter/material.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/modules/setting/setting.dart';

class AboutUS extends StatefulWidget {
  @override
  _AboutUSState createState() {
    return _AboutUSState();
  }
}

class _AboutUSState extends State<AboutUS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding:EdgeInsets.all(10),
      children: <Widget>[
        Container(
          height: 60,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  "About Us",
                  style: TextStyle(
                      fontFamily: GoloFont,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: GoloColors.secondary1),
                ),
              ),
            ],
          ),
        ),
        Text(
          Setting.aboutusContent,
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "V - VISION:",
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Setting.vision,
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "O - OPPORTUNITY:",
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Setting.OPPORTUNITY1,
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "I - INNOVATION:",
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Setting.INNOVATION,
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        )
        ,
        SizedBox(
          height: 10,
        ),
        Text(
          "C - CALLING:",
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Setting.CALLING,
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        )

        ,
        SizedBox(
          height: 10,
        ),
        Text(
          "E - EXCELLENCE:",
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Setting.EXCELLENCE,
          style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: GoloColors.secondary2),
        )
      ],
    );
  }
}
