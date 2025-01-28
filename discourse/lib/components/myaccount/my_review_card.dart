import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Individual MyReview cards to show course review details that are made by the user.
class MyReviewCard extends StatelessWidget {
  const MyReviewCard({super.key, required this.review});
  final IndividualCourseReview review;

  @override
  Widget build(BuildContext context) {
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);
    return Semantics(
        label: 'Go to the review detail for this course',
        button: true,
        child: GestureDetector(
          onTap: () {
            appState.changePages('/myreviewdetail', param1: review);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColor().separator))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Wrap(
                    children: [
                      Text(review.course!.courseName,
                          style: const TextStyle(
                              fontFamily: 'RegularText',
                              fontSize: 21,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Container(
                    child: Text(
                  review.course!.courseNumber,
                  style: const TextStyle(fontFamily: 'RegularText', fontSize: 18),
                )),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'By: ${review.instructor!.firstName} ${review.instructor!.lastName}',
                    style: const TextStyle(fontFamily: 'RegularText', fontSize: 14),
                  )
                ),
                Container(
                    child: Wrap(
                  children: [
                    Text(
                      review.reviewDetail,
                      style: const TextStyle(fontFamily: 'RegularText', fontSize: 13),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
