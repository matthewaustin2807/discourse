import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/myaccount/my_bookmark_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// My Bookmarks Page
class MyBookmarksPage extends StatefulWidget {
  const MyBookmarksPage({super.key, required this.courseReviewService, required this.firebaseAuth});
  final CourseReviewService courseReviewService;
  final FirebaseAuth firebaseAuth;

  @override
  State<MyBookmarksPage> createState() => _MyBookmarksPageState();
}

class _MyBookmarksPageState extends State<MyBookmarksPage> {
  late Future<List<CourseReview>> futureBookmarks;
  late Future<List<Course>> futureCourseNames;
  String? courseSearched;

  @override
  void initState() {
    super.initState();
    futureBookmarks = widget.courseReviewService
        .getMyBookmarks(widget.firebaseAuth.currentUser!.uid);
    futureCourseNames = widget.courseReviewService
        .getAllCourseNamesFromMyBookmarks(
            widget.firebaseAuth.currentUser!.uid);
  }

  /// Search for a bookmark using course name
  void searchCourse(val) {
    if (val.isEmpty) {
      futureBookmarks = widget.courseReviewService
          .getMyBookmarks(widget.firebaseAuth.currentUser!.uid);
    } else {
      futureBookmarks = widget.courseReviewService
          .getMyBookmarksFilteredByCourse(
              widget.firebaseAuth.currentUser!.uid, val);
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
              parentContext: context, pageName: 'My Bookmarks', isForm: false),
          Container(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.95,
            ),
            child: Column(
              children: [
                FutureBuilder(
                    future: Future.wait([futureCourseNames]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SearchModule<Course>(
                            callbackAction: searchCourse,
                            data: snapshot.data![0]);
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                Container(
                  constraints:
                      BoxConstraints(maxHeight: screenSize.height * 0.67),
                  child: FutureBuilder(
                      future: futureBookmarks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            padding: const EdgeInsets.only(top: 0),
                            children:
                                List.generate(snapshot.data!.length, (idx) {
                              return IndexedSemantics(
                                  index: idx,
                                  child: MyBookmarkCard(
                                    bookmark: snapshot.data![idx],
                                  ));
                            }),
                          );
                        } else {
                          return const CircularProgressIndicator.adaptive();
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
