import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Compact card to be shown in My Account page showing My Reviews
class CompactReviewCard extends StatelessWidget {
  const CompactReviewCard({super.key, required this.review});
  final IndividualCourseReview review;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return GestureDetector(
        onTap: () {
          appState.changePages('/myreviewdetail', param1: review);
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.4,
            maxHeight: screenSize.width * 0.4
          ),
          margin: const EdgeInsets.only(left: 4, top: 12, bottom: 12, right: 12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: AppColor().darkPurple,
                      border: Border(
                          bottom: BorderSide(color: AppColor().separator)),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            review.course!.courseName,
                            style: TextStyle(
                                fontFamily: 'RegularText',
                                color: AppColor().textActiveSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(review.course!.courseNumber,
                          style: TextStyle(
                              fontFamily: 'RegularText',
                              color: AppColor().textActiveSecondary))
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(4),
                  child: Wrap(
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                          review.reviewDetail,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'RegularText',
                            fontSize: 12,
                          ))
                    ],
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
