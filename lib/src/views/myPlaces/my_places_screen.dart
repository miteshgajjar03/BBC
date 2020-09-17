import 'package:flutter/material.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/controls/images/MyImageHelper.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

class MyPlacesScreen extends StatefulWidget {
  final List<City> cities;
  MyPlacesScreen({this.cities});
  @override
  _MyPlacesScreenState createState() => _MyPlacesScreenState();
}

class _MyPlacesScreenState extends State<MyPlacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: Localized.of(context).trans(LocalizedKey.myPlaces) ?? "",
      ),
      body: Container(
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
                child: _buildCityGridView(),
              ),
            )
          ],
        ),
      ),
    );
  }

// ### City list
  Widget _buildCityGridView() => new GridView.count(
        // padding: EdgeInsets.only(
        //   top: 5,
        //   bottom: 5,
        // ),
        crossAxisCount: 2,
        childAspectRatio: 0.815, //715,
        children: List.generate(
          widget.cities.length,
          (index) {
            return _buildCityCell(index);
          },
        ),
      );

  Widget _buildCityCell(int imageIndex) => Container(
        child: Container(
          //margin: EdgeInsets.only(right: 8, bottom: 8),
          padding: EdgeInsets.all(6),
          height: 350,
          child: GestureDetector(
            child: _buildMyPlace(
              city: widget.cities[imageIndex],
            ),
            onTap: () {
              HomeNav(context: context).openCity(
                widget.cities[imageIndex],
              );
            },
          ),
        ),
      );

  Widget _buildMyPlace({
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
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: Colors.grey[200],
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [Colors.transparent, Colors.black.withAlpha(200)],
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
  }
}
