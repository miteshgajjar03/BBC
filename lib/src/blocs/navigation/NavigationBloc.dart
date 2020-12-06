import 'package:flutter/material.dart';
import 'package:getgolo/src/entity/Category.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/entity/PlaceType.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/src/views/citydetail/CityDetail.dart';
import 'package:getgolo/src/views/myPlaces/add_place_screen.dart';
import 'package:getgolo/src/views/myPlaces/my_places_screen.dart';
import 'package:getgolo/src/views/place_detail/PlaceDetail.dart';
import 'package:getgolo/src/views/profile/profile_screen.dart';
import 'package:getgolo/src/views/review_rating/add_review_screen.dart';
import 'package:getgolo/src/views/review_rating/review_list_screen.dart';

class HomeNav {
  BuildContext _context;

  HomeNav({
    @required BuildContext context,
  }) {
    this._context = context;
  }

  // ### ACTIONS
  void openCity(City city) {
    if (city == null) {
      return;
    }
    navigateToCityDetail(city);
  }

  void navigateToCityDetail(City city) {
    // Navigator.of(context, rootNavigator: true).pushReplacement(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => CityDetail(city: city)),);

    Navigator.of(_context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        // transitionDuration: const Duration(milliseconds: 222),
        pageBuilder: (BuildContext context, _, __) {
          return CityDetail(city: city);
        },
        // transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        //   return SlideTransition(
        //     child: child,
        //     position:
        //         animation.drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
        //   );
        // },
        fullscreenDialog: true,
      ),
    );
  }

  void openMyPlace({
    @required PlaceListType placeListType,
    Category category,
  }) {
    Navigator.of(_context, rootNavigator: false).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context, _, __) {
          return MyPlacesScreen(
            listType: placeListType,
            category: category,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  /// ### Place
  void openPlace(Place place,PlaceListType type) {
    if (place == null) {
      return;
    }
    //LoadingHub.showLoadingDialog(_context);
    //PlaceProvider.getPlaceComments(place.id).then((comments) {
    //LoadingHub.closeLoadingDialog();
    // Comment list
    //place.setComments(comments);
    // Open place
    _openPlace(place,type);
    //});
  }

  void _openPlace(Place place,PlaceListType type) {
    if (place == null) {
      return;
    }
    // Navigator.of(context, rootNavigator: true).pushReplacement(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => PlaceDetail(place: place)));
    Navigator.of(_context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        // transitionDuration: const Duration(milliseconds: 222),
        pageBuilder: (BuildContext context, _, __) {
          return PlaceDetail(
            place: place,type: type,
          );
        },
        // transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        //   return SlideTransition(
        //     child: child,
        //     position:
        //         animation.drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
        //   );
        // },
        fullscreenDialog: true,
      ),
    );
  }

  void openProfile() {
    Navigator.of(_context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        // transitionDuration: const Duration(milliseconds: 222),
        pageBuilder: (BuildContext context, _, __) {
          return ProfileScreen();
        },
        fullscreenDialog: true,
      ),
    );
  }

  // void openReviewList({
  //   @required List<Review> review,
  //   @required int placeID,
  // }) {
  //   Navigator.of(_context, rootNavigator: true).push(
  //     PageRouteBuilder(
  //       opaque: true,
  //       pageBuilder: (BuildContext context, _, __) {
  //         return ReviewListScreen(
  //           reviews: review,
  //           placeID: placeID,
  //         );
  //       },
  //       fullscreenDialog: true,
  //     ),
  //   );
  // }

  void openWriteReview({
    @required int placeID,
  }) {
    Navigator.of(_context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context, _, __) {
          return AddReviewScreen(
            placeID: placeID,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  void openAddPlace() {
    Navigator.of(_context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context, _, __) {
          return AddPlaceScreen();
        },
        fullscreenDialog: true,
      ),
    );
  }
}
