import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddReviewScreen extends StatefulWidget {
  final int placeID;
  _AddReviewScreenState createState() => _AddReviewScreenState();
  AddReviewScreen({
    @required this.placeID,
  });
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _reviewController = TextEditingController();

  double _placeRating = 0;

  //
  // Add REVIEW
  //
  _addReview({@required BuildContext ctx}) async {
    hideKeyboard(ctx);
    if (_placeRating == 0) {
      showSnackBar(
        'Please select your rating.',
        ctx,
      );
    } else if (_reviewController.text.trim().length == 0) {
      showSnackBar(
        'Please enter your review.',
        ctx,
      );
    } else {
      final progress = getProgressIndicator(
        context: ctx,
      );
      await progress.show();

      Map<String, dynamic> dict = {};
      dict['comment'] = _reviewController.text;
      dict['score'] = _placeRating.toString();
      dict['place_id'] = widget.placeID;
      print('ADD REVIEW JSON :: $dict');

      final api = Platform().shared.baseUrl + "app/createReview";
      final response = await Api.requestPost(
        api,
        dict,
        null,
      );
      try {
        await progress.hide();
        final res = json.decode(response.json) as Map<String, dynamic>;
        var isSuccess = res['responseCode'] as int == 200;
        if (isSuccess) {
          showSnackBar(
            res['message'] as String ?? 'Review Added Succcessfully!',
            ctx,
          );
          Future.delayed(Duration(seconds: 2)).then(
            (value) => Navigator.of(ctx).pop(),
          );
        }
      } catch (error) {
        showSnackBar(
          error.toString(),
          ctx,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(
        title: Localized.of(context).trans(LocalizedKey.writeReview) ?? "",
        showBackButton: true,
        backOnPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Builder(
        builder: (fbContext) {
          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16.0),
            children: [
              Row(
                children: [
                  Text(
                    'Rate This Place:',
                    style: TextStyle(
                      fontFamily: GoloFont,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  RatingBar(
                    glow: false,
                    unratedColor: Colors.grey[400],
                    onRatingUpdate: (rating) {
                      _placeRating = rating;
                    },
                    itemBuilder: (ctx, idx) {
                      return Icon(
                        Icons.star,
                        color: Colors.yellow[700],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                ),
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _reviewController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 160,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a review',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              ButtonTheme(
                height: 50.0,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: GoloColors.primary,
                  shape: StadiumBorder(),
                  onPressed: () {
                    _addReview(
                      ctx: fbContext,
                    );
                  },
                  child: Text(
                    "Submit Review",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
