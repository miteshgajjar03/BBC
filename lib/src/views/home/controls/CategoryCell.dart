import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getgolo/modules/services/platform/lara/lara.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/entity/Category.dart';

class CategoryCell extends StatefulWidget {
  final Category category;

  CategoryCell({Key key, this.category}) : super(key: key);

  @override
  _CategoryCellState createState() {
    return _CategoryCellState();
  }
}

class _CategoryCellState extends State<CategoryCell> {
  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget getImageWidget(String url) {
    if (url != null && url.isNotEmpty) {
      String extension = url.split(".").last;
      if (extension == "svg") {
        return SvgPicture.network("${Lara.baseUrlImage}$url");
      } else {
        return Container(
            height: 30,
            width: 30,
            child: Image.network(
              "${Lara.baseUrlImage}$url",
            ));
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: hexToColor(
            widget.category.colorCode,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getImageWidget(
                widget.category.iconMapMarker,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Text(
                  widget.category.name ?? "",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: GoloFont,
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
