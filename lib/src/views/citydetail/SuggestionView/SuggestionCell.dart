import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/modules/controls/images/MyImageHelper.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/entity/Place.dart';

class SuggestionCell extends StatefulWidget {
  final Place place;
  final Function(int) onBookmarkPressed;
  SuggestionCell({
    Key key,
    this.place,
    this.onBookmarkPressed,
  }) : super(key: key);
  @override
  _SuggestionCell createState() {
    return _SuggestionCell();
  }
}

class _SuggestionCell extends State<SuggestionCell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          //1. Image
          MyImage.from(
            (widget.place.featuredMediaUrl != null)
                ? widget.place.featuredMediaUrl
                : '',
            borderRadius: new BorderRadius.all(
              Radius.circular(15),
            ),
            color: GoloColors.secondary3,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.white,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getPlaceTypes(widget.place) ?? "",
                              style: TextStyle(
                                fontFamily: GoloFont,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.place.name ?? "",
                              style: TextStyle(
                                fontFamily: GoloFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    (widget.place.doubleRate > 0)
                                        ? widget.place.doubleRate
                                                .toStringAsFixed(1) ??
                                            ''
                                        : '(0 Reviews)',
                                    style: TextStyle(
                                      fontFamily: GoloFont,
                                      color: GoloColors.primary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: widget.place.hasRate,
                                  child: Icon(
                                    DenLineIcons.star,
                                    color: GoloColors.primary,
                                    size: 11,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    (widget.place.reviewCount ?? 0) <= 0
                                        ? ""
                                        : "(${widget.place.reviewCount})", // review count
                                    style: TextStyle(
                                      fontFamily: GoloFont,
                                      color: GoloColors.primary,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                widget.place.priceRange ?? r"$",
                                style: TextStyle(
                                  fontFamily: GoloFont,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          //2. Button
          Align(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: 8,
                right: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              height: 32,
              width: 32,
              child: CupertinoButton(
                padding: EdgeInsets.only(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  right: 6,
                ),
                onPressed: () {
                  if (widget.onBookmarkPressed != null) {
                    widget.onBookmarkPressed(widget.place.id);
                  } else {
                    widget.place.addToWishList(
                      context: context,
                      onAdded: (message) {
                        showSnackBar(message, context);
                      },
                    );
                  }
                },
                child: Icon(
                  DenLineIcons.bookmark,
                  size: 20,
                  color: GoloColors.secondary2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getPlaceTypes(Place place) {
    var string =
        place.placeTypes.map((placeType) => placeType.name).toList().join("\n");
    return string;
  }
}
