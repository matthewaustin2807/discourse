import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

/// Compact card to be shown in My Account page showing My Bookmarks
class CompactBookmarkCard extends StatelessWidget {
  const CompactBookmarkCard({super.key, required this.review});
  final CourseReview review;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState = Provider.of<ApplicationState>(context, listen: false);

    return GestureDetector(
        onTap: () {
          appState.changePages('/reviewdetail', param1: review, param2: true);
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.4,
            maxHeight: screenSize.width * 0.4
          ),
          margin: const EdgeInsets.only(left: 4, top: 12, bottom: 12, right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
            color: AppColor().darkPurple,
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      Text(
                        review.course!.courseName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'RegularText',
                            color: AppColor().textActiveSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(review.course!.courseNumber,
                        style: TextStyle(
                          color: AppColor().textActiveSecondary,
                          fontFamily: 'RegularText',
                        ))),
                Container(
                  margin: const EdgeInsets.only(top: 32),
                  alignment: Alignment.centerLeft,
                  child: Text('Overall Rating',
                      style: TextStyle(
                        color: AppColor().textActiveSecondary,
                        fontFamily: 'RegularText',
                      )),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 8),
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      label: 'Rated ${review.averageOverallRating} stars out of 5',
                      child: RatingBarIndicator(
                        rating: review.averageOverallRating,
                        itemBuilder: (context, index) {
                          return Icon(Icons.star,
                              color: AppColor().starColorSecondary);
                        },
                        itemCount: 5,
                        itemSize: 24,
                        direction: Axis.horizontal,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
