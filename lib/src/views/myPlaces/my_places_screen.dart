import 'package:flutter/material.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/providers/request_services/PlaceProvider.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';
import 'package:getgolo/src/views/citydetail/SuggestionView/SuggestionCell.dart';
import 'package:progress_dialog/progress_dialog.dart';

enum PlaceListType { wishList, myPlace }

class MyPlacesScreen extends StatefulWidget {
  final PlaceListType listType;

  MyPlacesScreen({
    @required this.listType,
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
    return (widget.listType == PlaceListType.wishList)
        ? 'You have not added any place in your wishlist'
        : 'You have not added any place yet';
  }

  String get noDataFoundMessage {
    return (widget.listType == PlaceListType.wishList)
        ? 'No wishlist found'
        : 'No place found';
  }

  //
  // GET PLACE LIST
  //
  Future<List<Place>> _getPlaces() async {
    final places = await PlaceProvider.getPlace(
      listType: widget.listType,
    );
    return places;
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
        showBackButton: widget.listType == PlaceListType.myPlace,
        backOnPressed: () {
          if (widget.listType == PlaceListType.myPlace) {
            Navigator.of(context).pop();
          }
        },
        title: Localized.of(context).trans(
              (widget.listType == PlaceListType.myPlace)
                  ? LocalizedKey.myPlaces
                  : LocalizedKey.myWishlist,
            ) ??
            '',
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
            print('snapshot.hasData ${snapshot.hasData}');
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
                          child: _buildWishlistGridView(
                            places: snapshot.data,
                            context: fbContext,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return getCenterInfoWidget(
                  message: emptyListMessage,
                );
              }
            } else {
              return getCenterInfoWidget(
                message: noDataFoundMessage,
              );
            }
          },
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
        final progress = ProgressDialog(
          ctx,
          isDismissible: false,
        );
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
  Widget _buildWishlistGridView({
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
            return _buildWishListCell(
              place: place,
              onBookmarkPressed: (placeId) {
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
              },
            );
          },
        ),
      );

  Widget _buildWishListCell({
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
