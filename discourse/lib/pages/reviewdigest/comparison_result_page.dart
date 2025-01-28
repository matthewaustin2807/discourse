import 'package:discourse/components/reviewdigest/compared_review_column.dart';
import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/service/bookmark_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Page to show comparison between two courses.
class ComparisonResultPage extends StatefulWidget {
  const ComparisonResultPage(
      {super.key,
      required this.firstCourse,
      required this.secondCourse,
      required this.firebaseAuth,
      required this.bookmarkService});
  final FirebaseAuth firebaseAuth;
  final CourseReview firstCourse;
  final CourseReview secondCourse;
  final BookmarkService bookmarkService;

  @override
  State<ComparisonResultPage> createState() => _ComparisonResultPageState();
}

class _ComparisonResultPageState extends State<ComparisonResultPage> {
  late Future<bool> firstCourseBookmarked;
  late Future<bool> secondCourseBookmarked;

  @override
  void initState() {
    super.initState();
    firstCourseBookmarked = widget.bookmarkService.isBookmarked(
        widget.firebaseAuth.currentUser!.uid,
        widget.firstCourse.courseReviewId!);
    secondCourseBookmarked = widget.bookmarkService.isBookmarked(
        widget.firebaseAuth.currentUser!.uid,
        widget.secondCourse.courseReviewId!);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          DiscourseAppBar(
              parentContext: context, pageName: 'Comparing', isForm: false),
          FutureBuilder(
              future:
                  Future.wait([firstCourseBookmarked, secondCourseBookmarked]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      padding: const EdgeInsets.only(left: 12),
                      constraints: BoxConstraints(
                        maxWidth: screenSize.width,
                        maxHeight: screenSize.height * 0.7,
                      ),
                      child: SingleChildScrollView(
                          child: Row(
                        children: [
                          ComparedReviewColumn(
                            review: widget.firstCourse,
                            isBookmarked: snapshot.data![0],
                            firebaseAuth: widget.firebaseAuth,
                            bookmarkService: widget.bookmarkService,
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: AppColor().separator,
                          ),
                          ComparedReviewColumn(
                            review: widget.secondCourse,
                            isBookmarked: snapshot.data![1],
                            firebaseAuth: widget.firebaseAuth,
                            bookmarkService: widget.bookmarkService,
                          )
                        ],
                      )));
                } else {
                  return const SizedBox.shrink();
                }
              }),
        ],
      ),
    );
  }
}
