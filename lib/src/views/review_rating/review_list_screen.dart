import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

class ReviewListScreen extends StatefulWidget {
  final List<Review> reviews;
  final int placeID;
  _ReviewListScreenState createState() => _ReviewListScreenState();

  ReviewListScreen({
    @required this.reviews,
    @required this.placeID,
  });
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: GoloColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          HomeNav(context: context).openWriteReview(
            placeID: widget.placeID,
          );
        },
        child: Icon(Icons.add),
      ),
      body: (widget.reviews != null && widget.reviews.length > 0)
          ? ListView.builder(
              itemCount: widget.reviews.length,
              itemBuilder: (lbContext, index) {
                final review = widget.reviews[index];
                return _buildReviewRow(review: review);
              },
            )
          : Center(
              child: Text(
                'No Reviews',
                style: TextStyle(
                  fontFamily: GoloFont,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
    );
  }

  Widget _buildReviewRow({
    @required Review review,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(
          10.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                review.user.avatarUrl,
              ),
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
                      Expanded(
                        child: Text(
                          review.user.name,
                          style: TextStyle(
                            fontFamily: GoloFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      RatingBar(
                        glow: false,
                        unratedColor: Colors.grey[400],
                        ignoreGestures: true,
                        onRatingUpdate: null,
                        initialRating: double.parse(review.score.toString()),
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
                    review.comment,
                    //maxLines: 2,
                    //overflow: TextOverflow.ellipsis,
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
