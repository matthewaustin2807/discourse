import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

/// Individual MyBookmark cards to show course review details that have been bookmarked by the user.
class MyBookmarkCard extends StatelessWidget {
  const MyBookmarkCard({super.key, required this.bookmark});
  final CourseReview bookmark;

  @override
  Widget build(BuildContext context) {
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);
    return Semantics(
        label: 'Go to the details for this course',
        button: true,
        child: GestureDetector(
            onTap: () {
              appState.changePages('/reviewdetail',
                  param1: bookmark, param2: true);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: AppColor().separator))),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Text(bookmark.course!.courseName,
                          style: const TextStyle(
                              fontFamily: 'RegularText',
                              fontSize: 18,
                              fontWeight: FontWeight.bold))),
                  Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(bookmark.course!.courseNumber,
                          style: const TextStyle(
                            fontFamily: 'RegularText',
                            fontSize: 18,
                          ))),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                        'By: ${bookmark.instructor!.firstName} ${bookmark.instructor!.lastName}',
                        style: const TextStyle(
                          fontFamily: 'RegularText',
                          fontSize: 13,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MergeSemantics(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: const Text('Overall Rating',
                                style: TextStyle(
                                  fontFamily: 'RegularText',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Semantics(
                                label: 'Rated ${2.5} stars',
                                child: RatingBarIndicator(
                                    rating: bookmark.averageOverallRating,
                                    itemCount: 5,
                                    itemSize: 24,
                                    itemBuilder: (context, idx) {
                                      return Icon(Icons.star,
                                          color: AppColor().starColorPrimary);
                                    })),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Semantics(
                      label: 'List of tags associated with this course',
                      child: Wrap(
                        children: List.generate(bookmark.tags.length, (idx) {
                          return IndexedSemantics(
                              index: idx,
                              child: TagWidget(
                                tagName: bookmark.tags[idx],
                              ));
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
