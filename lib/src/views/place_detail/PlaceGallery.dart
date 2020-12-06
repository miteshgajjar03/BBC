import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/services/platform/lara/lara.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

class PlaceGallery extends StatefulWidget {
  @override
  PlaceGalleryState createState() {
    return PlaceGalleryState();
  }
  // final List<Review> reviews;
  final List<String> gallery;
  PlaceGallery({@required this.gallery});
}

class PlaceGalleryState extends State<PlaceGallery> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final List<Widget> imageSliders =widget.gallery.map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(Lara.baseUrlImage+item, fit: BoxFit.cover, width: 1000.0),

              ],
            )
        ),
      ),
    )).toList();
    return Scaffold(
      appBar: buildAppBar(
        title: "Gallery",
        showBackButton: true,
        backOnPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
          children: [
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  height: height-150,
                  viewportFraction: 1.0,
                  autoPlay: false,
                  reverse: false,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.gallery.map((url) {
                int index = widget.gallery.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]
      ),
    );
  }
}
