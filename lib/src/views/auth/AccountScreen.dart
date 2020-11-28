import 'package:flutter/material.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/providers/request_services/Api+auth.dart';
import 'package:getgolo/src/views/myPlaces/my_places_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../main.dart';

class AccountScreen extends StatefulWidget {
  //@override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {},
              child: Text(
                'Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {},
              child: Text(
                'My Place',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {},
              child: Text(
                'WishList',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {},
              child: Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return AccountScreenState();
  }
}

class AccountScreenState extends State<AccountScreen> {
  _logout() async {
    showConfirmationAlert(
      context: context,
      actionButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
      cancelAction: () {},
      confirmAction: () async {
        final progress = ProgressDialog(
          context,
          isDismissible: false,
          type: ProgressDialogType.Normal,
        );
        await progress.show();
        final _ = await ApiAuth.logout();
        await progress.hide();
        //if (response.isSuccess) {
        Future.delayed(
          Duration(
            milliseconds: 100,
          ),
        ).then(
          (value) {
            final BottomNavigationBar bottomBar = globalKey.currentWidget;
            bottomBar.onTap(3);
          },
        );

        //}
      },
      message: 'Are you sure you want to logout?',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Text(
                      "Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.only(),
                              child: ButtonTheme(
                                height: 50.0,
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: GoloColors.primary,
                                  shape: StadiumBorder(),
                                  onPressed: () {
                                    HomeNav(context: context).openProfile();
                                  },
                                  child: Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.only(),
                              child: ButtonTheme(
                                height: 50.0,
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: GoloColors.primary,
                                  shape: StadiumBorder(),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) {
                                          return MyPlacesScreen(
                                            listType: PlaceListType.myPlace,
                                          );
                                        },
                                      ),
                                    );
                                    //HomeNav(context: context).openMyPlace();
                                  },
                                  child: Text(
                                    "My Place",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: Padding(
                          //     padding: EdgeInsets.only(),
                          //     child: ButtonTheme(
                          //       height: 50.0,
                          //       child: RaisedButton(
                          //         textColor: Colors.white,
                          //         color: GoloColors.primary,
                          //         shape: StadiumBorder(),
                          //         onPressed: () {},
                          //         child: Text(
                          //           "WishList",
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.only(),
                              child: ButtonTheme(
                                height: 50.0,
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: GoloColors.primary,
                                  shape: StadiumBorder(),
                                  onPressed: () {
                                    _logout();
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
