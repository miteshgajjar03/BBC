import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/blocs/navigation/NavigationBloc.dart';
import 'package:getgolo/src/blocs/place_detail/PlaceDetailBloc.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/src/providers/BlocProvider.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

import 'add_review_screen.dart';

class ReviewListScreen extends StatefulWidget {
  // final List<Review> reviews;
  final int placeID;
  final Place place;

  _ReviewListScreenState createState() => _ReviewListScreenState();

  ReviewListScreen({@required this.placeID, @required this.place});
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  void openWriteReview({@required int placeID, BuildContext context}) {
    Navigator.of(context, rootNavigator: true)
        .push(
          PageRouteBuilder(
            opaque: true,
            pageBuilder: (BuildContext context, _, __) {
              return AddReviewScreen(
                placeID: placeID,
              );
            },
            fullscreenDialog: true,
          ),
        )
        .then((value) => setState(() {
              bloc = PlaceDetailBloc(widget.place);
              bloc.fetchData(widget.placeID);
            }));
  }

  //Bloc
  PlaceDetailBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get list amenity for place
    bloc = PlaceDetailBloc(widget.place);
    bloc.fetchData(widget.placeID);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaceDetailBloc>(
        bloc: bloc,
        child: Scaffold(
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
              openWriteReview(placeID: widget.placeID, context: context);
              // HomeNav(context: context).openWriteReview(
              //   placeID: widget.placeID,
              // );
            },
            child: Icon(Icons.add),
          ),
          body: StreamBuilder<Place>(
              stream: bloc.placeController,
              builder: (context, AsyncSnapshot<Place> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return getCenterInfoWidget(
                    message: 'Fetching reviews',
                  );
                } else if (snapshot.hasError) {
                  return _buildCenterWidgetForShowError(
                    ctx: context,
                    message: snapshot.error.toString(),
                  );
                } else if (snapshot.hasData) {
                  var place = snapshot.data;
                  return (bloc.reviews != null && bloc.reviews.length > 0)
                      ? ListView.builder(
                          itemCount: bloc.reviews.length,
                          itemBuilder: (lbContext, index) {
                            final review = bloc.reviews[index];
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
                        );
                } else {
                  return _buildCenterWidgetForShowError(
                    ctx: context,
                    message:
                        'Error while fetching place details!\nPlease try again later!',
                  );
                }
              }),
        ));
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
                      RatingBar.builder(
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

  //
  // BUILD CENTER WIDGET FOR ERROR
  //
  Widget _buildCenterWidgetForShowError({
    @required BuildContext ctx,
    @required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getCenterInfoWidget(
            message: message,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}
