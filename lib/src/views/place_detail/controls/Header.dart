import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/modules/controls/images/MyImageHelper.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/views/myPlaces/add_place_screen.dart';
import 'package:getgolo/src/views/place_detail/PlaceGallery.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailHeader extends StatefulWidget {
  final String category;
  final String City;
  final Place place;

  PlaceDetailHeader({Key key, this.place, this.category,this.City}) : super(key: key);

  @override
  _PlaceDetailHeaderState createState() {
    return _PlaceDetailHeaderState();
  }
}

class _PlaceDetailHeaderState extends State<PlaceDetailHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MyImage.from(
            widget.place != null ? widget.place.featuredMediaUrl : "",
            color: GoloColors.secondary3,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(180)],
                stops: [0.4, 1.0],
              ),
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.only(left: 25, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.City ?? "",
                    style: TextStyle(
                      fontFamily: GoloFont,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.place != null ? (widget.place.name ?? "") : "",
                    style: TextStyle(
                      fontFamily: GoloFont,
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.place != null
                            ? (widget.place.doubleRate.toStringAsFixed(1) ?? "")
                            : "",
                        style: TextStyle(
                          fontFamily: GoloFont,
                          fontSize: 15,
                          color: GoloColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Visibility(
                        visible: (widget.place != null && widget.place.hasRate),
                        child: Icon(
                          DenLineIcons.star,
                          color: GoloColors.primary,
                          size: 12,
                        ),
                      ),
                      Visibility(
                        visible: (widget.place != null
                                ? (widget.place.reviewCount ?? 0)
                                : 0) >
                            0,
                        child: Container(
                          margin: EdgeInsets.only(left: 6),
                          child: Text(
                            "(${widget.place != null ? (widget.place.reviewCount ?? 0) : 0} reviews)",
                            style: TextStyle(
                              fontFamily: GoloFont,
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        child: Container(
                          margin: EdgeInsets.only(left: 6, right: 6),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.all(
                              Radius.circular(3),
                            ),
                            color: Colors.white.withAlpha(120),
                          ),
                        ),
                        visible: widget.place != null &&
                            widget.place.priceRange != null &&
                            widget.place.priceRange.isNotEmpty,
                      ),
                      Text(
                        widget.place != null
                            ? (widget.place.priceRange ?? "")
                            : "",
                        style: TextStyle(
                          fontFamily: GoloFont,
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6, right: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(3)),
                          color: Colors.white.withAlpha(120),
                        ),
                      ),
                      Text(
                        widget.place != null ? widget.category : "",
                        style: TextStyle(
                          fontFamily: GoloFont,
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        child: new GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              PageRouteBuilder(
                                opaque: true,
                                pageBuilder: (BuildContext context, _, __) {
                                  return PlaceGallery(
                                    gallery: widget.place.gallery,
                                  );
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                DenLineIcons.gallery,
                                color: Colors.white,
                                size: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  "Gallery",
                                  style: TextStyle(
                                    fontFamily: GoloFont,
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                  //overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        visible: widget.place.gallery != null &&
                                widget.place.gallery.length > 0
                            ? true
                            : false,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        child: new GestureDetector(
                          onTap: () async{
                            if (await canLaunch(widget.place.video)) {
                            await launch(widget.place.video, forceSafariVC: false);
                            } else {
                            throw 'Could not launch $widget.place.video';
                            }
                            // Navigator.of(context, rootNavigator: true).push(
                            //   PageRouteBuilder(
                            //     opaque: true,
                            //     pageBuilder: (BuildContext context, _, __) {
                            //       return PlaceVideo(
                            //         videoUrl: widget.place.video,
                            //       );
                            //     },
                            //     fullscreenDialog: true,
                            //   ),
                            // );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                DenLineIcons.video,
                                color: Colors.white,
                                size: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  "Video",
                                  style: TextStyle(
                                    fontFamily: GoloFont,
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                  //overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        visible: widget.place.video != null ? true : false,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
