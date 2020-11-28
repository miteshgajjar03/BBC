import 'package:flutter/material.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';
import 'package:getgolo/src/views/home/controls/CityCell.dart';

class Cities extends StatefulWidget {
  final List<City> cities;
  Cities({this.cities});
  @override
  _CitiesState createState() {
    return _CitiesState();
  }
}

class _CitiesState extends State<Cities> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: Localized.of(context).trans(LocalizedKey.allCities) ?? "",
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
                margin: EdgeInsets.only(bottom: 5),
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
          margin: EdgeInsets.all(
            6.0,
          ),
          height: 200, //350,
          child: GestureDetector(
            child: CityCell(
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
}
