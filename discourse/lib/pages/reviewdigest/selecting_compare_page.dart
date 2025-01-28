import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/reviewdigest/review_digest_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/service/bookmark_service.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:discourse/service/course_service.dart';
import 'package:discourse/service/instructor_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Page to allow users to select a course to compare with
class SelectCourseToComparePage extends StatefulWidget {
  const SelectCourseToComparePage(
      {super.key,
      required this.courseService,
      required this.instructorService,
      required this.courseReviewService,
      required this.firstCourse,
      required this.bookmarkService,
      required this.firebaseAuth});
  final CourseService courseService;
  final InstructorService instructorService;
  final CourseReviewService courseReviewService;
  final CourseReview firstCourse;
  final BookmarkService bookmarkService;
  final FirebaseAuth firebaseAuth;

  @override
  State<SelectCourseToComparePage> createState() =>
      _SelectCourseToComparePageState();
}

class _SelectCourseToComparePageState extends State<SelectCourseToComparePage> {
  late Future<List<CourseReview>> futureReviews;
  late Future<List<Course>> futureCourseNames;
  late Future<List<Instructor>> futureInstructorNames;
  late Future<List<Bookmark>> futureBookmarks;
  String? courseSearched;
  String? instructorSearched;
  final List<bool> _selectedSearchMode = [true, false];

  @override
  void initState() {
    super.initState();
    futureReviews = widget.courseReviewService
        .getAllCoursesForComparison(widget.firstCourse.courseReviewId!);
    futureCourseNames = widget.courseService.getAllCourse();
    futureInstructorNames = widget.instructorService.getAllInstructors();
    futureBookmarks = widget.bookmarkService
        .getBookmarksByUser(widget.firebaseAuth.currentUser!.uid);
  }

  /// Search a course from the search bar using Course name
  void searchCourse(val) {
    if (val.isEmpty) {
      futureReviews = widget.courseReviewService
          .getAllCoursesForComparison(widget.firstCourse.courseReviewId!);
    } else {
      futureReviews = widget.courseReviewService.getAllCoursesFilteredByCourse(
          val,
          forCompare: true,
          currentCourseReviewId: widget.firstCourse.courseReviewId);
    }
    setState(() => courseSearched = val);
  }

  /// Search a course from the search bar using Instructor name
  void searchInstructor(val) {
    if (val.isEmpty) {
      futureReviews = widget.courseReviewService
          .getAllCoursesForComparison(widget.firstCourse.courseReviewId!);
    } else {
      futureReviews = widget.courseReviewService
          .getAllCoursesFilteredByInstructor(val,
              forCompare: true,
              currentCourseReviewId: widget.firstCourse.courseReviewId);
    }
    setState(() => instructorSearched = val);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: ListView(
        children: [
          DiscourseAppBar(
              parentContext: context, pageName: 'Compare With', isForm: false),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          child: const Text('Search by: ')),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            // The button that is tapped is set to true, and the others to false.
                            for (int i = 0;
                                i < _selectedSearchMode.length;
                                i++) {
                              _selectedSearchMode[i] = i == index;
                            }
                          });
                        },
                        borderWidth: 2,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                        selectedBorderColor: Colors.deepPurple,
                        selectedColor: Colors.white,
                        fillColor: AppColor().darkPurple,
                        color: Colors.black,
                        constraints: const BoxConstraints(
                          minHeight: 30.0,
                          minWidth: 80.0,
                        ),
                        isSelected: _selectedSearchMode,
                        children: const [
                          Text('Course'),
                          Text('Instructor'),
                        ],
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    future:
                        Future.wait([futureCourseNames, futureInstructorNames]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (_selectedSearchMode[0]) {
                          return SearchModule<Course>(
                              data: snapshot.data![0] as List<Course>,
                              callbackAction: searchCourse);
                        } else {
                          return SearchModule<Instructor>(
                            data: snapshot.data![1] as List<Instructor>,
                            callbackAction: searchInstructor,
                          );
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenSize.width,
                    maxHeight: screenSize.height * 0.58,
                  ),
                  child: FutureBuilder(
                      future: Future.wait([futureReviews, futureBookmarks]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            addSemanticIndexes: true,
                            padding: const EdgeInsets.only(top: 0),
                            children: [
                              snapshot.data![0].isEmpty
                                  ? Center(
                                      child: Text('No Reviews To Display',
                                          style: TextStyle(
                                              fontFamily: 'RegularText',
                                              color: AppColor()
                                                  .textActiveTertiary)))
                                  : Column(
                                      children: List.generate(
                                          snapshot.data![0].length, (idx) {
                                      return IndexedSemantics(
                                          index: idx,
                                          child: ReviewDigestCard(
                                            bookmarks: snapshot.data![1]
                                                as List<Bookmark>,
                                            review: snapshot.data![0][idx]
                                                as CourseReview,
                                            inCompare: true,
                                            firstCourse: widget.firstCourse,
                                            bookmarkService:
                                                widget.bookmarkService,
                                            firebaseAuth: widget.firebaseAuth,
                                          ));
                                    })),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
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
