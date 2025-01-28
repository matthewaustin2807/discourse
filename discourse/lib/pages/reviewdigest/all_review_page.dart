import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/reviewdigest/review_card.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:flutter/material.dart';

/// Page containing all existing individual reviews for a particular Course Review
class AllReviewPage extends StatefulWidget {
  const AllReviewPage({super.key, required this.courseReview});

  final CourseReview courseReview;

  @override
  State<AllReviewPage> createState() => _AllReviewPageState();
}

class _AllReviewPageState extends State<AllReviewPage> {
  late Future<List<IndividualCourseReview>> futureIndividualReviews;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          DiscourseAppBar(
              parentContext: context, pageName: 'All Reviews', isForm: false),
          Container(
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(
              maxWidth: screenSize.width,
              maxHeight: screenSize.height * 0.7,
            ),
            child: ListView(
              padding: const EdgeInsets.only(top: 0),
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColor().separator))),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Semantics(
                          label:
                              'All reviews for ${widget.courseReview.course!.courseName}',
                          child: Text(widget.courseReview.course!.courseName,
                              style: const TextStyle(
                                  fontFamily: 'RegularText',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        child: Text(widget.courseReview.course!.courseNumber,
                            style: const TextStyle(
                              fontFamily: 'RegularText',
                              fontSize: 24,
                            )),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  ExcludeSemantics(
                                    child: Icon(Icons.person,
                                        color: AppColor().textActiveTertiary),
                                  ),
                                  Semantics(
                                      label:
                                          'Instructor is ${widget.courseReview.instructor!.firstName} ${widget.courseReview.instructor!.lastName}',
                                      child: Text(
                                          'By ${widget.courseReview.instructor!.firstName} ${widget.courseReview.instructor!.lastName}',
                                          style: TextStyle(
                                              fontFamily: 'RegularText',
                                              color: AppColor()
                                                  .textActiveTertiary))),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  ExcludeSemantics(
                                    child: Icon(Icons.star,
                                        color: AppColor().textActiveTertiary),
                                  ),
                                  Semantics(
                                      label:
                                          'Rated ${widget.courseReview.averageOverallRating.toStringAsFixed(2)} stars',
                                      child: Text(
                                          '${widget.courseReview.averageOverallRating.toStringAsFixed(2)} stars',
                                          style: TextStyle(
                                              fontFamily: 'RegularText',
                                              color: AppColor()
                                                  .textActiveTertiary))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                      children: List.generate(
                          widget.courseReview.individualCourseReviews!.length,
                          (idx) {
                    return IndexedSemantics(
                        index: idx,
                        child: ReviewCard(
                          individualReview:
                              widget.courseReview.individualCourseReviews![idx],
                        ));
                  })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
