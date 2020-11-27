import 'dart:async';
import 'package:getgolo/src/entity/PlaceCategory.dart';
import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/modules/controls/images/MyImageHelper.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/views/citydetail/map/MyMapStyle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapViewCity extends StatefulWidget {
  final List<PlaceCategory> categories;
  final City city;
  final bool isFullScreen;
  final double zoom;
  GoogleMapViewCity({this.categories, this.city, this.isFullScreen, this.zoom});
  @override
  _GoogleMapView createState() => _GoogleMapView();
}

class _GoogleMapView extends State<GoogleMapViewCity> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set<Marker>();
  int loaded = 0;
  Place placeToShow;
  PlaceCategory categoryToShow;
  var isShowedPlace = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _clear();
  }

  void _clear() {
    this.placeToShow = null;
    isShowedPlace = false;
    this.categoryToShow = null;
  }

  @override
  Widget build(BuildContext context) {
    getMarkers(context);
    return _buildMap();
  }

  Widget _buildMap() {
    return Stack(children: [
      GoogleMap(
        padding: EdgeInsets.all(0),
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.city.lat, widget.city.lng),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(MyMapStyle.normalMap);
          final cameraPosition = CameraPosition(
            target: LatLng(
              widget.city.lat,
              widget.city.lng,
            ),
            zoom: widget.zoom,
          );
          controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
          setState(() {});
        },
        myLocationButtonEnabled: false,
        markers: markers,
      ),
      // Header
      Visibility(
        visible: widget.isFullScreen,
        child: Container(
          height: 105,
          alignment: Alignment.centerLeft,
          child: SafeArea(
              bottom: false,
              child: Row(children: [
                // Back button
                Container(
                  margin: EdgeInsets.only(left: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        color: Color.fromRGBO(
                          0,
                          0,
                          0,
                          0.2,
                        ),
                      )
                    ],
                    color: Colors.white,
                  ),
                  height: 40,
                  width: 140,
                  child: CupertinoButton(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(DenLineIcons.angle_left,
                              size: 15, color: GoloColors.secondary2),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20, left: 10),
                          child: Text(
                            "Back to list",
                            style: TextStyle(
                                fontFamily: GoloFont,
                                fontSize: 16,
                                color: GoloColors.secondary1),
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      _clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // Show button
                // Container(
                //   margin: EdgeInsets.only(left: 15),
                //   height: 40,
                //   width: 113,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       boxShadow: [
                //         BoxShadow(
                //             blurRadius: 2,
                //             offset: Offset(0, 1),
                //             color: Color.fromRGBO(0, 0, 0, 0.2))
                //       ],
                //       color: Colors.white),
                //   child: CupertinoButton(
                //       padding: EdgeInsets.all(0),
                //       child: Row(
                //         children: <Widget>[
                //           Padding(
                //             padding: EdgeInsets.only(left: 20),
                //             child: Text(
                //               "Show all",
                //               style: TextStyle(
                //                   fontFamily: GoloFont,
                //                   fontSize: 16,
                //                   color: GoloColors.primary),
                //             ),
                //           ),
                //           Padding(
                //               padding: EdgeInsets.only(right: 11, left: 7),
                //               child: Icon(
                //                 DenLineIcons.angle_down,
                //                 color: GoloColors.secondary2,
                //                 size: 12,
                //               ))
                //         ],
                //       ),
                //       onPressed: () {}),
                // )
              ])),
        ),
      ),
      Align(alignment: Alignment.bottomCenter, child: _showPopOverPlace())
    ]);
  }

  void getMarkers(BuildContext context) {
    this.markers.clear();
    List.generate(
      widget.categories != null ? widget.categories.length : 0,
      (index) {
        String imageString;
        switch (widget.categories[index].id) {
          case 11:
            imageString = 'assets/iconGolo/icon-see@3x.png';
            break;
          case 12:
            imageString = 'assets/iconGolo/icon-eat-drink@3x.png';
            break;
          case 13:
            imageString = 'assets/iconGolo/icon-stay@3x.png';
            break;
          case 21:
            imageString = 'assets/iconGolo/icon-shop@3x.png';
            break;
          default:
            imageString = 'assets/iconGolo/icon-shop@3x.png';
        }
        widget.categories[index].places.forEach(
          (place) async {
            if (place.lat != null && place.lng != null) {
              var latlng = LatLng(place.lat, place.lng);
//          final Uint8List markerIcon = await getBytesFromAsset(imageString, 100);
//          final marker = Marker(
//            position: latlng,
//            markerId: MarkerId("${place.id}"),
//            icon: BitmapDescriptor.fromBytes(markerIcon),
//            onTap: () {
//              if (widget.isFullScreen) {
//                setState(() {
//                  placeToShow = place;
//                  isShowedPlace = true;
//                  categoryToShow = widget.categories[index];
//                });
//              }
//            },
//          );
//          markers.add(marker);
              BitmapDescriptor.fromAssetImage(
                      ImageConfiguration(size: Size(60, 60)), imageString)
                  .then((value) {
                final marker = Marker(
                  position: latlng,
                  markerId: MarkerId("${place.id}"),
                  icon: value,
                  onTap: () {
                    if (widget.isFullScreen) {
                      setState(() {
                        placeToShow = place;
                        isShowedPlace = true;
                        categoryToShow = widget.categories[index];
                      });
                    }
                  },
                );
                markers.add(marker);
              });
            }
          },
        );
      },
    );
  }

//  Future<Uint8List> getBytesFromAsset(String path, int width) async {
//    ByteData data = await rootBundle.load(path);
//    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//    ui.FrameInfo fi = await codec.getNextFrame();
//    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
//  }

  void _handlePressedInfowindow(Place place) {
    HomeNav(context: context).openPlace(place);
  }

  Widget _showPopOverPlace() {
    if (placeToShow == null || !isShowedPlace) {
      return Container();
    }
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 100),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  color: Color.fromARGB(51, 0, 0, 0),
                  offset: Offset(0, 1)),
            ]),
        margin: EdgeInsets.only(bottom: 35, left: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: <Widget>[
              // Place Content
              GestureDetector(
                onTap: () {
                  _handlePressedInfowindow(placeToShow);
                },
                child: Scaffold(
                  body: Row(
                    children: <Widget>[
                      // Image Place
                      Container(
                          width: 150,
                          child: MyImage.from(placeToShow.featuredMediaUrl)),
                      Expanded(
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          categoryToShow.name,
                                          style: TextStyle(
                                              fontFamily: GoloFont,
                                              fontSize: 15,
                                              color: GoloColors.secondary2),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          width: 120,
                                          child: Text(
                                            placeToShow.name ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: GoloFont,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: GoloColors.secondary1),
                                          )),
                                      Container(
                                          height: 20,
                                          width: 160,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      placeToShow.rate ?? "-",
                                                      style: TextStyle(
                                                        fontFamily: GoloFont,
                                                        color:
                                                            GoloColors.primary,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(DenLineIcons.star,
                                                      size: 12),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                        (placeToShow.reviewCount ??
                                                                    0) >
                                                                0
                                                            ? "${placeToShow.reviewCount}"
                                                            : "",
                                                        style: TextStyle(
                                                          fontFamily: GoloFont,
                                                          fontSize: 16,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text(r"$$",
                                                    style: TextStyle(
                                                      fontFamily: GoloFont,
                                                      color:
                                                          GoloColors.secondary2,
                                                      fontSize: 16,
                                                    )),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 24,
                  width: 24,
                  margin: EdgeInsets.only(right: 20, top: 20),
                  child: CupertinoButton(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        DenLineIcons.cancel,
                        size: 24,
                        color: GoloColors.secondary2,
                      ),
                      onPressed: () {
                        setState(() {
                          isShowedPlace = !isShowedPlace;
                        });
                      }),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: Offset(5, 5),
                        spreadRadius: 5)
                  ]),
                  margin: EdgeInsets.only(left: 100, top: 20),
                  alignment: Alignment.center,
                  child: CupertinoButton(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        DenLineIcons.bookmark,
                        size: 24,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
