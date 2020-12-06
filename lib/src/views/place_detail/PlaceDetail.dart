import 'dart:math';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/blocs/place_detail/PlaceDetailBloc.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/src/providers/BlocProvider.dart';
import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/views/citydetail/map/PlaceGoogleMapView.dart';
import 'package:getgolo/src/views/myPlaces/my_places_screen.dart';
import 'package:getgolo/src/views/place_detail/controls/Contact.dart';
import 'package:getgolo/src/views/place_detail/controls/Header.dart';
import 'package:getgolo/src/views/place_detail_overview/PlaceDetailOverview.dart';
import 'package:getgolo/src/views/review_rating/review_list_screen.dart';

import 'controls/Facilities.dart';
import 'controls/OpenTime.dart';

class PlaceDetail extends StatefulWidget {
  final Place place;
  final PlaceListType type;

  PlaceDetail({Key key, this.place,this.type}) : super(key: key);

  @override
  _PlaceDetailState createState() {
    return _PlaceDetailState();
  }
}

class _PlaceDetailState extends State<PlaceDetail> {
  ScrollController _scrollController;
  Color _headerBackgroundColor = GoloColors.clear;

  Color _titleColor = GoloColors.clear;
  // Show full opening time
  bool showFullOpeningTime = false;
  //Bloc
  PlaceDetailBloc bloc;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        var offset = _scrollController.offset;
        // Header background color
        var alpha = offset > 0 ? min(255, offset.toInt()) : 0;
        _headerBackgroundColor = GoloColors.primary.withAlpha(alpha);
        // Title color
        _titleColor = Colors.white.withAlpha(offset > 255 ? 255 : 0);
        // State
        setState(() {});
      });
    // Get list amenity for place

    bloc = PlaceDetailBloc(widget.place);
    bloc.fetchData(widget.place.id);
  }

  void openReviewList({
    @required List<Review> review,
    @required int placeID, BuildContext context
  }) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context, _, __) {
          return ReviewListScreen(
            place: widget.place,
            placeID: placeID,
          );
        },
        fullscreenDialog: true,
      ),
    ).then((value) => getPlaceDetail());
  }

  void getPlaceDetail()
  {
    // Get list amenity for place
    setState(() {
      bloc = PlaceDetailBloc(widget.place);
      bloc.fetchData(widget.place.id);
    });
  }

  String getPlaceTypeString()
  {
    String placeString="";
    for (var placetype in bloc.placeTypes) {
      if(placeString.isEmpty) {
        placeString = placeString + placetype.name;
      }else
        {
          placeString = placeString +" , "+ placetype.name;
        }
    }
    return placeString;
  }

  String getPlaceCategoryString()
  {
    String categoryString="";
    for (var category in bloc.categories) {
      if(categoryString.isEmpty) {
        categoryString = categoryString + category.name;
      }else
      {
        categoryString = categoryString +" , "+ category.name;
      }
    }
    return categoryString;
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaceDetailBloc>(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<Place>(
          stream: bloc.placeController,
          builder: (context, AsyncSnapshot<Place> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return getCenterInfoWidget(
                message: 'Fetching Place Details',
              );
            } else if (snapshot.hasError) {
              return _buildCenterWidgetForShowError(
                ctx: context,
                message: snapshot.error.toString(),
              );
            } else if (snapshot.hasData) {
              var place = snapshot.data;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              controller: _scrollController,
                              padding: EdgeInsets.all(0),
                              children: <Widget>[
                                Container(
                                  height: 250,
                                  child: PlaceDetailHeader(
                                    place: place,
                                    category: bloc.categories.length > 0
                                        ? bloc.categories[0].name
                                        : "",
                                    City:  bloc.city!=null
                                        ? bloc.city.name
                                        : "",
                                  ),
                                ),
                                Container(
                                  height: bloc.amenities.length > 0 ? 95 : 0,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                          child: bloc.amenities.length > 0
                                              ? FacilitiesView(
                                                  amenities: bloc.amenities,
                                                )
                                              : Container()),
                                      Container(
                                        height: 1,
                                        color: GoloColors.secondary3
                                            .withAlpha(180),
                                      )
                                    ],
                                  ),
                                ),
                                // Overview
                                _buildOverview(place),
                                //Place Category
                                _buildCategories(),
                                //Place Type
                                _buildPlaceType(),
                                // MAP VIEW
                                _buildMapview(place),
                                // Location & contacts
                                _buildLocationAndContact(place),
                                // OPEN TIME
                                Visibility(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 25,
                                      left: 25,
                                      right: 25,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text("Opening Time",
                                              style: TextStyle(
                                                  fontFamily: GoloFont,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      GoloColors.secondary1)),
                                        ),
                                        PlaceDetailOpenTime(
                                          place: place,
                                          showFull: showFullOpeningTime,
                                        ),
                                        Visibility(
                                          child: CupertinoButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              setState(() {
                                                showFullOpeningTime =
                                                    !showFullOpeningTime;
                                              });
                                            },
                                            child: Text(
                                                showFullOpeningTime
                                                    ? "Show less"
                                                    : "Show more",
                                                style: TextStyle(
                                                    fontFamily: GoloFont,
                                                    fontSize: 16,
                                                    color: GoloColors.primary,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          visible: (place != null
                                                  ? place.openingTime.length
                                                  : 0) >
                                              2,
                                        )
                                      ],
                                    ),
                                  ),
                                  visible: (place != null
                                          ? place.openingTime.length
                                          : 0) >
                                      0,
                                ),
                                // REVIEW
                                //if (bloc.reviews.length > 0)
                                SafeArea(
                                  maintainBottomViewPadding: true,
                                  top: false,
                                  child: GestureDetector(
                                    onTap: () {
                                     openReviewList( review: bloc.reviews,
                                       placeID: bloc.placeId,context: context);
                                      // HomeNav(context: context).openReviewList(
                                      //   review: bloc.reviews,
                                      //   placeID: bloc.placeId,
                                      // );
                                    },
                                    child: Container(
                                      height: 64.0,
                                      padding: const EdgeInsets.all(12.0),
                                      color:
                                          GoloColors.secondary1.withAlpha(15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Review (${bloc.reviews.length})',
                                            style: TextStyle(
                                              fontFamily: GoloFont,
                                              fontSize: 21,
                                              color: GoloColors.secondary1,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: GoloColors.secondary1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                /*Container(
                                margin: EdgeInsets.only(top: 25),
                                color: GoloColors.secondary1.withAlpha(15),
                                child: Container(
                                  margin: EdgeInsets.all(25),
                                  child: PlaceDetailReview(
                                    place: place,
                                    reviews: bloc.reviews,
                                  ),
                                ),
                              ),
                              Container(
                                height: 10,
                              ),*/
                              ],
                            ),
                          ),
                          /*Container(
                                height: 80,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: 15),
                                child: Container(
                                  height: 45,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: GoloColors.primary,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Book",
                                      style: TextStyle(
                                          fontFamily: GoloFont,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),*/
                        ],
                      ),
                    ),
                    _buildHeader(place, context),
                  ],
                ),
              );
            } else {
              return _buildCenterWidgetForShowError(
                ctx: context,
                message:
                    'Error while fetching place details!\nPlease try again later!',
              );
            }
          },
        ),
      ),
    );
  }

  //
  // BUILD CENTER WIDGET FOR ERROR
  //
  Widget _buildCenterWidgetForShowError({
    @required BuildContext ctx,
    @required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getCenterInfoWidget(
            message: message,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
  }

  // ### HEADER
  Widget _buildHeader(Place place, BuildContext context) {
    return Container(
      height: 95,
      color: _headerBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: _headerBackgroundColor,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                child: Icon(DenLineIcons.angle_left,
                    size: 22, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: Text(
                  place != null ? (place.name ?? "") : "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: GoloFont,
                    fontSize: 24,
                    color: _titleColor,
                  ),
                ),
              ),
              Visibility(
                child: CupertinoButton(
                  child: Icon(
                    DenLineIcons.bookmark,
                    size: 24,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.place.addToWishList(
                      context: context,
                      onAdded: (message) {
                        showSnackBar(message, context);
                      },
                    );
                  },
                ),
                visible: widget.type==PlaceListType.wishList ? false : true,
              )

            ],
          ),
        ),
      ),
    );
  }

  // ### ACTIONS
  void openOverview(BuildContext context, Place place) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 222),
        pageBuilder: (BuildContext context, _, __) {
          return PlaceDetailOverview(
            content: place.description,
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            child: child,
            position:
                animation.drive(Tween(begin: Offset(0.5, 0), end: Offset.zero)),
          );
        },
        fullscreenDialog: true));
  }

  void _openMap(Place place) {
    Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 222),
        pageBuilder: (BuildContext context, _, __) {
          return Container(
            child: GoogleMapViewPlace(
              place: place,
              isFullScreen: true,
              zoom: 14,
            ),
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            child: child,
            position:
                animation.drive(Tween(begin: Offset(0.5, 0), end: Offset.zero)),
          );
        },
        fullscreenDialog: true));
  }

  Widget _buildOverview(Place place) {
    if (place == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Overview",
            style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: GoloColors.secondary1),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 0),
            child: Text(
              place != null ? (place.description ?? "") : "",
              style: TextStyle(
                  fontFamily: GoloFont,
                  fontSize: 17,
                  color: GoloColors.secondary2),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              openOverview(context, place);
            },
            child: Text(
              "Show more",
              style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 16,
                color: GoloColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategories() {
    if (bloc.categories == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Place Category",
            style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: GoloColors.secondary1),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 0),
            child: Text(
              getPlaceCategoryString(),
              style: TextStyle(
                  fontFamily: GoloFont,
                  fontSize: 15,
                  color: GoloColors.secondary2),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceType() {
    if (bloc.placeTypes == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Place Types",
            style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: GoloColors.secondary1),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 0),
            child: Text(
              getPlaceTypeString(),
              style: TextStyle(
                  fontFamily: GoloFont,
                  fontSize: 15,
                  color: GoloColors.secondary2),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMapview(Place place) {
    if (place.lat == null && place.lng == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.all(0),
      height: 220,
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            margin: EdgeInsets.only(left: 25),
            alignment: Alignment.topLeft,
            child: Text(
              "Map View",
              style: TextStyle(
                  fontFamily: GoloFont,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: GoloColors.secondary1),
            ),
          ),
          GestureDetector(
            onTap: () {
              _openMap(place);
            },
            child: Container(
              height: 180,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              child: AbsorbPointer(
                child: Image.network(
                  getMapURLFrom(
                    latitude: place.lat,
                    longitude: place.lng,
                  ),
                  fit: BoxFit.cover,
                ),
                // child: GoogleMapViewPlace(
                //   isFullScreen: false,
                //   zoom: 14,
                //   place: place,
                // ),
                absorbing: true,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLocationAndContact(Place place) {
    if (place == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Location & Contact",
              style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: GoloColors.secondary1,
              ),
            ),
          ),
          PlaceDetailContact(
            place: place,
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            color: GoloColors.secondary3.withAlpha(180),
            height: 1,
          )
        ],
      ),
    );
  }
}
