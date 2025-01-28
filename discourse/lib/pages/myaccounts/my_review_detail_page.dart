import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// My Review Detail Page
class MyReviewDetailPage extends StatelessWidget {
  const MyReviewDetailPage({super.key, required this.review});
  final IndividualCourseReview review;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          DiscourseAppBar(
              parentContext: context, pageName: 'Review Detail', isForm: false),
          Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.9,
                maxHeight: screenSize.height * 0.7,
              ),
              child: LayoutBuilder(builder: (context, boxConstraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      MergeSemantics(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: AppColor().separator))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.course!.courseNumber,
                                  style: const TextStyle(
                                    fontFamily: 'RegularText',
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(review.course!.courseName,
                                  style: const TextStyle(
                                    fontFamily: 'RegularText',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: AppColor().separator))),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('My Ratings',
                                style: TextStyle(
                                  fontFamily: 'RegularText',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            MergeSemantics(
                              child: Container(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Overall Rating',
                                        style: TextStyle(
                                          fontFamily: 'RegularText',
                                          fontSize: 18,
                                        )),
                                    Semantics(
                                        label: '${review.overallRating} stars',
                                        child: RatingBarIndicator(
                                          rating: review.overallRating,
                                          itemBuilder: (context, index) {
                                            return Icon(Icons.star,
                                                color: AppColor()
                                                    .starColorPrimary);
                                          },
                                          itemCount: 5,
                                          itemSize: 27,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            MergeSemantics(
                              child: Container(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Difficulty Rating',
                                        style: TextStyle(
                                          fontFamily: 'RegularText',
                                          fontSize: 18,
                                        )),
                                    Semantics(
                                      label:
                                          '${review.difficultyRating} out of 5',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text('Easy',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText')),
                                          Slider(
                                            divisions: 8,
                                            label: 2.5.toString(),
                                            value: review.difficultyRating,
                                            min: 0.0,
                                            max: 5.0,
                                            onChanged: null,
                                          ),
                                          const Text('Hard',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText'))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: AppColor().separator))),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MergeSemantics(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          const Text('Taken',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText',
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              '${review.semester} ${review.year}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  MergeSemantics(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          const Text('Instructor',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText',
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              '${review.instructor!.firstName} ${review.instructor!.lastName}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  MergeSemantics(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          const Text('Grade',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText',
                                                  fontWeight: FontWeight.bold)),
                                          Text(review.grade),
                                        ],
                                      ),
                                    ),
                                  ),
                                  MergeSemantics(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          const Text('Work/week',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText',
                                                  fontWeight: FontWeight.bold)),
                                          Text(review.estimatedWorkload),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Semantics(
                                      label:
                                          'List of tags associated with this review',
                                      child: const Text('Course Tags',
                                          style: TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                  Wrap(
                                      children: List.generate(
                                          review.tags.length, (idx) {
                                    return IndexedSemantics(
                                        index: idx,
                                        child: TagWidget(
                                            tagName: review.tags[idx]));
                                  })),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: const Text(
                              'My Detailed Review',
                              style: TextStyle(
                                fontFamily: 'RegularText',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Container(
                              child: Wrap(
                                children: [Text(review.reviewDetail)],
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
        ],
      ),
    );
  }
}
