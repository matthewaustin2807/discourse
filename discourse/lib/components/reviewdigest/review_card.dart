import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Card to represent an Individual Course Review to be shown in Review Detail page
class ReviewCard extends StatelessWidget {
  const ReviewCard(
      {super.key,
      required this.individualReview,
      this.showSeparator = true,
      this.fromInstructorPage = false});
  final IndividualCourseReview individualReview;
  final bool showSeparator;
  final bool fromInstructorPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showSeparator
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColor().separator)))
          : null,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MergeSemantics(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Semantics(
                          label:
                              'Review by ${individualReview.reviewerUsername}',
                          child: Text(individualReview.reviewerUsername,
                              style: const TextStyle(
                                  fontFamily: 'RegularText',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Semantics(
                      label:
                          'Rated ${individualReview.overallRating.toString()} stars',
                      child: RatingBarIndicator(
                        itemBuilder: (context, idx) {
                          return Icon(Icons.star,
                              color: AppColor().starColorPrimary);
                        },
                        itemCount: 5,
                        itemSize: 18,
                        rating: individualReview.overallRating,
                      )),
                ),
                fromInstructorPage ? Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                      individualReview.course!.courseNumber,
                      style: TextStyle(
                          fontFamily: 'RegularText',
                          fontSize: 14,
                          color: AppColor().textActiveTertiary)),
                ) : const SizedBox.shrink(),
                Container(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                        '${individualReview.semester} ${individualReview.year}',
                        style: TextStyle(
                            fontFamily: 'RegularText',
                            fontSize: 14,
                            color: AppColor().textActiveTertiary))),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 8),
            child: Text(individualReview.reviewDetail,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'RegularText',
                    color: AppColor().textActiveTertiary)),
          ),
        ],
      ),
    );
  }
}
