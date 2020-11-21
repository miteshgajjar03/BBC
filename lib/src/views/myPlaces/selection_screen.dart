import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/modules/state/AppState.dart';
import 'package:getgolo/src/entity/PlaceInitialData.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

enum SelectionType { category, placeType, country, city }

class SelectionData {
  int id = 0;
  String name = '';
  bool isSelected = false;

  SelectionData({
    this.id,
    this.name,
    this.isSelected,
  });
}

extension on SelectionType {
  String get title {
    switch (this) {
      case SelectionType.category:
        return 'Select Category';
      case SelectionType.placeType:
        return 'Select Place Type';
      case SelectionType.country:
        return 'Select Country';
      case SelectionType.city:
        return 'Select City';
    }
    return '';
  }
}

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
  final Function(List<SelectionData>) onSelectValue;
  final SelectionType selectionType;
  final PlaceInitialData objInitialData;

  SelectionScreen({
    this.onSelectValue,
    this.selectionType,
    this.objInitialData,
  });
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<SelectionData> arrSelection = [];
  Future _future;

  @override
  void initState() {
    super.initState();

    _future = _getData();
  }

  Future _getData() async {
    switch (widget.selectionType) {
      case SelectionType.category:
        AppState().categories.forEach((element) {
          arrSelection.add(
            SelectionData(
              id: element.id,
              name: element.name,
              isSelected: element.isSelected,
            ),
          );
        });
        break;
      case SelectionType.placeType:
        break;
      case SelectionType.country:
        fillData() {
          widget.objInitialData.arrCountries.forEach(
            (element) {
              arrSelection.add(
                SelectionData(
                  id: element.id,
                  name: element.name,
                  isSelected: element.isSelected,
                ),
              );
            },
          );
        }
        if (widget.objInitialData.arrCountries.length == 0) {
          final isSuccess = await widget.objInitialData.getCountryCityList();
          if (isSuccess) {
            fillData();
          }
        } else {
          fillData();
        }
        break;
      case SelectionType.city:
        final objCountry = widget.objInitialData.arrCountries.firstWhere(
          (element) => element.isSelected,
        );
        if (objCountry != null) {
          final arrCity = widget.objInitialData.getCitiesFrom(
            countryID: objCountry.id,
          );

          arrCity.forEach(
            (element) {
              arrSelection.add(
                SelectionData(
                  id: element.id,
                  name: element.name,
                  isSelected: element.isSelected,
                ),
              );
            },
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        showBackButton: true,
        title: widget.selectionType.title,
        backOnPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  'Fetching data please wait...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: GoloFont,
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: (arrSelection.length > 0)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: arrSelection.length,
                            itemBuilder: (lbCtx, index) {
                              final selection = arrSelection[index];
                              return _buildAmenitiesRow(
                                selection: selection,
                                onPressed: () {
                                  _setSelected(selectionData: selection);
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              widget.selectionType == SelectionType.city
                                  ? 'No city found for selected country'
                                  : 'No Data Found!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: GoloFont,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: ButtonTheme(
                      height: 50.0,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: GoloColors.primary,
                        shape: StadiumBorder(),
                        onPressed: () {
                          final selectedArr = arrSelection
                              .where(
                                (element) => element.isSelected,
                              )
                              .toList();
                          widget.onSelectValue(selectedArr);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: GoloFont,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  //
  // SetSelectedValue
  //
  _setSelected({
    @required SelectionData selectionData,
  }) {
    switch (widget.selectionType) {
      case SelectionType.category:
        selectionData.isSelected = !selectionData.isSelected;
        break;
      case SelectionType.placeType:
        break;
      case SelectionType.city:
      case SelectionType.country:
        arrSelection.forEach((element) {
          element.isSelected = false;
        });
        final index = arrSelection.indexWhere(
          (element) => element.id == selectionData.id,
        );
        arrSelection[index].isSelected = true;
    }
    setState(() {});
  }

  //
  // BUILD AMENITIES
  //
  Widget _buildAmenitiesRow({
    @required SelectionData selection,
    @required Function onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              selection.isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
            onPressed: onPressed,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              selection.name,
              style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
