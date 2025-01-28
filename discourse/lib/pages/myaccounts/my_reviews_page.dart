import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/myaccount/my_review_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// My Review Page
class MyReviewPage extends StatefulWidget {
  const MyReviewPage({super.key, required this.courseReviewService, required this.firebaseAuth});
  final CourseReviewService courseReviewService;
  final FirebaseAuth firebaseAuth;

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  late Future<List<IndividualCourseReview>> futureMyReviews;
  late Future<List<Course>> futureCourseNames;
  String? courseSearched;

  @override
  void initState() {
    super.initState();
    futureMyReviews = widget.courseReviewService
        .getMyReviews(widget.firebaseAuth.currentUser!.uid);
    futureCourseNames = widget.courseReviewService
        .getAllExistingMyReviews(widget.firebaseAuth.currentUser!.uid);
  }

  /// Searched for a My Review entry using Course Name
  void searchCourse(val) {
    if (val.isEmpty) {
      futureMyReviews = widget.courseReviewService
          .getMyReviews(widget.firebaseAuth.currentUser!.uid);
    } else {
      futureMyReviews =
          widget.courseReviewService.getMyReviewsFiltered(val, widget.firebaseAuth.currentUser!.uid);
    }
    setState(() => courseSearched = val);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          DiscourseAppBar(
              parentContext: context, pageName: 'My Reviews', isForm: false),
          Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.95,
              ),
              child: Column(
                children: [
                  FutureBuilder(
                      future: futureCourseNames,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SearchModule<Course>(
                              callbackAction: searchCourse,
                              data: snapshot.data!);
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height * 0.68,
                    ),
                    child: FutureBuilder(
                        future: futureMyReviews,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
                              padding: const EdgeInsets.only(top: 0),
                              children:
                                  List.generate(snapshot.data!.length, (idx) {
                                return IndexedSemantics(
                                    index: idx,
                                    child: MyReviewCard(
                                      review: snapshot.data![idx],
                                    ));
                              }),
                            );
                          } else {
                            return const CircularProgressIndicator.adaptive();
                          }
                        }),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
