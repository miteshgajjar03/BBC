import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

class ReviewListScreen extends StatefulWidget {
  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: Localized.of(context).trans(LocalizedKey.reviews) ?? "",
        showBackButton: true,
        backOnPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (lbContext, index) {
          return _buildReviewRow();
        },
      ),
    );
  }

  Widget _buildReviewRow() {
    return GestureDetector(
      onTap: () {
        HomeNav(context: context).openWriteReview();
      },
      child: Container(
        padding: EdgeInsets.all(
          10.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Circle Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ankit Khatri',
                        style: TextStyle(
                          fontFamily: GoloFont,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RatingBar(
                        glow: false,
                        unratedColor: Colors.grey[400],
                        ignoreGestures: true,
                        onRatingUpdate: null,
                        initialRating: 3,
                        itemSize: 28,
                        itemBuilder: (ctx, idx) {
                          return Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Very delicious and easy to order and pick up. We will definitely do it again. There are so many yummy looking items to try. Reasonable prices, too.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: GoloFont,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
