import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

class AddReviewScreen extends StatefulWidget {
  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: Localized.of(context).trans(LocalizedKey.writeReview) ?? "",
        showBackButton: true,
        backOnPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
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
                  print(rating);
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
              onPressed: () {},
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
      ),
    );
  }
}
