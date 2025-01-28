import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/service/bookmark_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

/// Card containing individual Course Review for Review Digest page.
class ReviewDigestCard extends StatefulWidget {
  ReviewDigestCard(
      {super.key,
      required this.review,
      this.inCompare = false,
      this.firstCourse,
      required this.bookmarks,
      required this.bookmarkService,
      required this.firebaseAuth});
  final bool inCompare;
  final CourseReview review;
  final CourseReview? firstCourse;
  final List<Bookmark> bookmarks;
  final BookmarkService bookmarkService;
  final FirebaseAuth firebaseAuth;

  @override
  State<ReviewDigestCard> createState() => _ReviewDigestCardState();
}

class _ReviewDigestCardState extends State<ReviewDigestCard> {
  late bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.bookmarks
          .map((bookmark) => bookmark.courseId)
          .contains(widget.review.courseReviewId)) {
        isBookmarked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);
    return Semantics(
        label: widget.inCompare
            ? 'Compare with ${widget.review.course!.courseName}'
            : 'Look at the details of ${widget.review.course!.courseName} course',
        button: true,
        child: GestureDetector(
            onTap: () {
              widget.inCompare
                  ? appState.changePages('/compareresult',
                      param1: widget.firstCourse!, param2: widget.review)
                  : appState.changePages('/reviewdetail',
                      param1: widget.review, param2: isBookmarked);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColor().separator,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Wrap(
                              children: [
                                Text(
                                  widget.review.course!.courseName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RegularText'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              widget.review.course!.courseNumber,
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'RegularText'),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'By: ${widget.review.instructor!.firstName} ${widget.review.instructor!.lastName}',
                              style: const TextStyle(
                                  fontSize: 13, fontFamily: 'RegularText'),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Semantics(
                                label:
                                    'This course is rated ${widget.review.averageOverallRating} stars',
                                container: true,
                                child: RatingBarIndicator(
                                  itemBuilder: (context, idx) {
                                    return Icon(Icons.star,
                                        color: AppColor().starColorPrimary);
                                  },
                                  itemCount: 5,
                                  itemSize: 24,
                                  rating: widget.review.averageOverallRating,
                                )),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Semantics(
                              label: 'List of tags associated with this review',
                              child: Wrap(
                                children: List.generate(
                                    widget.review.tags.length, (idx) {
                                  return IndexedSemantics(
                                      index: idx,
                                      child: TagWidget(
                                          tagName: widget.review.tags[idx]));
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        widget.inCompare
                            ? const SizedBox.shrink()
                            : Semantics(
                                label:
                                    'Bookmark ${widget.review.course!.courseName}',
                                button: true,
                                child: IconButton(
                                  icon: isBookmarked
                                      ? Icon(Icons.bookmark,
                                          color: AppColor().darkPurple)
                                      : const Icon(
                                          Icons.bookmark_border,
                                        ),
                                  onPressed: () async {
                                    if (isBookmarked) {
                                      await widget.bookmarkService
                                          .deleteBookmark(
                                              widget.firebaseAuth.currentUser!
                                                  .uid,
                                              widget.review.courseReviewId!);
                                      setState(() => isBookmarked = false);
                                    } else {
                                      Bookmark bookmark = Bookmark(
                                          courseId:
                                              widget.review.courseReviewId!,
                                          userId: widget
                                              .firebaseAuth.currentUser!.uid);
                                      await widget.bookmarkService
                                          .addBookmark(bookmark);
                                      setState(() => isBookmarked = true);
                                    }
                                  },
                                ),
                              ),
                        widget.inCompare
                            ? const SizedBox.shrink()
                            : Semantics(
                                label:
                                    'Compare ${widget.review.course!.courseName} with another course',
                                button: true,
                                child: ElevatedButton(
                                  onPressed: () {
                                    appState.changePages('/selectcompare',
                                        param1: widget.review);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF7429E7),
                                  ),
                                  child: const Text('Compare'),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
