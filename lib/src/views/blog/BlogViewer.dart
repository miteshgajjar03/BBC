import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getgolo/modules/controls/helpers/MyUrlHelper.dart';
import 'package:getgolo/modules/controls/images/MyImageHelper.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/entity/Post.dart';

class BlogViewer extends StatefulWidget {
  final Post post;

  BlogViewer({Key key, this.post}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlogViewerState();
}

class _BlogViewerState extends State<BlogViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: MyImage.from(
                        widget.post.featuredMediaUrl ?? "",
                        color: GoloColors.secondary3,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(25),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              offset: Offset(0, 1),
                              color: Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.25,
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.post.categories.first,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: GoloFont,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: GoloColors.primary,
                              ),
                              maxLines: 10,
                            ),
                            Text(
                              widget.post.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: GoloFont,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 5, top: 5),
                      child: FittedBox(
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              offset: Offset(0, 1),
                              color: Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.15,
                              ),
                            )
                          ]),
                          child: CupertinoButton(
                            child: Icon(
                              DenLineIcons.angle_left,
                              size: 24,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(
                    20,
                  ),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: SingleChildScrollView(
        child: Html(
          data: widget.post.content ?? "",
          onLinkTap: (url) {
            MyUrlHelper.open(url);
          },
        ),
      ),
    );
  }
}
