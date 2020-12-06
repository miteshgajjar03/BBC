import 'package:flutter/material.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/entity/Category.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/entity/User.dart';
import 'package:getgolo/src/providers/request_services/PlaceProvider.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';
import 'package:getgolo/src/views/citydetail/SuggestionView/SuggestionCell.dart';

enum PlaceListType { wishList, myPlace, placeByCategory }

class MyPlacesScreen extends StatefulWidget {
  final PlaceListType listType;
  final Category category;

  MyPlacesScreen({
    @required this.listType,
    this.category,
  });

  @override
  _MyPlacesScreenState createState() => _MyPlacesScreenState();
}

class _MyPlacesScreenState extends State<MyPlacesScreen> {
  Future<List<Place>> _future;

  @override
  void initState() {
    super.initState();

    _future = _getPlaces();
  }

  String get fetchListTitle {
    return (widget.listType == PlaceListType.wishList)
        ? 'Fetching wish list'
        : 'Fetching places';
  }

  String get emptyListMessage {
    switch (widget.listType) {
      case PlaceListType.wishList:
        return 'You have not added any place in your wishlist';
        break;
      case PlaceListType.myPlace:
        return 'You have not added any place yet';
        break;
      case PlaceListType.placeByCategory:
        return 'No place found for selected category!';
        break;
    }
    return '';
  }

  String get title {
    switch (widget.listType) {
      case PlaceListType.wishList:
        return LocalizedKey.myWishlist;
        break;
      case PlaceListType.myPlace:
        return LocalizedKey.myPlaces;
        break;
      case PlaceListType.placeByCategory:
        return (widget.category != null) ? widget.category.name : 'Place';
        break;
    }
    return '';
  }

  String get noDataFoundMessage {
    return (widget.listType == PlaceListType.wishList)
        ? 'No wishlist found!\nTry pull to refresh to update your list!'
        : 'No place found';
  }

  //
  // GET PLACE LIST
  //
  Future<List<Place>> _getPlaces() async {
    if (widget.listType == PlaceListType.placeByCategory) {
      final places = await PlaceProvider.getPlaceByCategoryID(
        categoryIDs: [widget.category.id],
      );
      return places;
    } else {
      if (UserManager.shared.authToken.isNotEmpty) {
        final places = await PlaceProvider.getPlace(
          listType: widget.listType,
        );
        return places;
      }
      return null;
    }
  }

  Future _refresh() async {
    setState(() {
      _future = _getPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        showBackButton: (widget.listType != PlaceListType.wishList),
        backOnPressed: () {
          if (widget.listType != PlaceListType.wishList) {
            Navigator.of(context).pop();
          }
        },
        title: (widget.category != null)
            ? title
            : Localized.of(context).trans(title) ?? '',
      ),
      floatingActionButton: (widget.listType == PlaceListType.myPlace)
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              backgroundColor: GoloColors.primary,
              onPressed: () {
                HomeNav(context: context).openAddPlace();
              },
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
          future: _future,
          builder: (fbContext, AsyncSnapshot<List<Place>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return getCenterInfoWidget(
                message: fetchListTitle,
              );
            } else if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return Container(
                  margin: EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: _buildGridView(
                            places: snapshot.data,
                            context: fbContext,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return _showCenterWidgetWithPullToRefresh(
                  message: emptyListMessage,
                );
              }
            } else {
              String message = noDataFoundMessage;
              if (widget.listType == PlaceListType.wishList &&
                  UserManager.shared.authToken.isEmpty) {
                message = 'Please login to your account to get your wishlist!';
              }
              return _showCenterWidgetWithPullToRefresh(
                message: message,
              );
            }
          },
        ),
      ),
    );
  }

  //
  // SHOW CNETER TEXT WITH PULL TO REFRESH ENABLE
  //
  Widget _showCenterWidgetWithPullToRefresh({@required String message}) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
        ),
        child: getCenterInfoWidget(
          message: message,
        ),
      ),
    );
  }

  //
  // REMOVE FROM WISH LIST
  //
  _removeFromWishList({
    @required BuildContext ctx,
    @required Place place,
    @required Function(bool) onDelete,
  }) async {
    showConfirmationAlert(
      context: ctx,
      title: 'Confirmation',
      message: 'Are you sure you want to remove place from your wishlist?',
      actionButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
      confirmAction: () async {
        final progress = getProgressIndicator(context: ctx);
        progress.show();
        place.removeFromWishList(
          onRemove: (message, isSuccess) async {
            await progress.hide();
            onDelete(isSuccess);
            showSnackBar(message, ctx);
          },
        );
      },
      cancelAction: () {},
    );
  }

// ### City list
  Widget _buildGridView({
    @required BuildContext context,
    @required List<Place> places,
  }) =>
      new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.815, //715,
        children: List.generate(
          places.length,
          (index) {
            final place = places[index];
            return _buildListCell(
              place: place,
              onBookmarkPressed: (placeId) {
                if (widget.listType == PlaceListType.wishList) {
                  _removeFromWishList(
                    ctx: context,
                    place: place,
                    onDelete: (isSuccess) {
                      if (isSuccess) {
                        setState(() {
                          places.removeWhere(
                            (element) => element.id == placeId,
                          );
                        });
                      }
                    },
                  );
                } else {
                  place.addToWishList(
                    context: context,
                    onAdded: (msg) {
                      showSnackBar(msg, context);
                    },
                  );
                }
              },
            );
          },
        ),
      );

  Widget _buildListCell({
    @required Place place,
    @required Function(int) onBookmarkPressed,
  }) =>
      Container(
        child: Container(
          padding: EdgeInsets.all(6),
          height: 350,
          child: GestureDetector(
            child: SuggestionCell(
              place: place,
              onBookmarkPressed: onBookmarkPressed,
            ),
            onTap: () {
              HomeNav(context: context).openPlace(
                place,
              );
            },
          ),
        ),
      );

  /*Widget _buildMyWishList({
    @required City city,
  }) {
    return Stack(
      children: [
        MyImage.from(
          city.featuredImage,
          borderRadius: new BorderRadius.all(
            Radius.circular(15),
          ),
          color: Colors.grey[200],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color: Colors.grey[200],
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withAlpha(200),
              ],
              stops: [0.4, 1.0],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  city.name ?? '',
                  maxLines: 4,
                  style: TextStyle(
                    fontFamily: GoloFont,
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  city.country ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: GoloFont,
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }*/
}
