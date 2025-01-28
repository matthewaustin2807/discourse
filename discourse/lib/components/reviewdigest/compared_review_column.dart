import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/service/bookmark_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Column that will allow users to compare two courses together. Shown in Comparison Result page
class ComparedReviewColumn extends StatefulWidget {
  const ComparedReviewColumn(
      {super.key,
      required this.review,
      required this.isBookmarked,
      required this.bookmarkService,
      required this.firebaseAuth});
  final CourseReview review;
  final bool isBookmarked;
  final BookmarkService bookmarkService;
  final FirebaseAuth firebaseAuth;

  @override
  State<ComparedReviewColumn> createState() => _ComparedReviewColumnState();
}

class _ComparedReviewColumnState extends State<ComparedReviewColumn> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    setState(() => isBookmarked = widget.isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxWidth: screenSize.width * 0.45,
        maxHeight: screenSize.height * 0.7,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(widget.review.course!.courseName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'RegularText',
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(widget.review.course!.courseNumber,
                            style: const TextStyle(
                                fontFamily: 'RegularText', fontSize: 16))),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Icon(Icons.person,
                        color: AppColor().textActiveTertiary),
                  ),
                  Semantics(
                      label:
                          'Instructor is ${widget.review.instructor!.firstName} ${widget.review.instructor!.lastName}',
                      child: Text(
                          'By ${widget.review.instructor!.firstName} ${widget.review.instructor!.lastName}',
                          style: TextStyle(
                              color: AppColor().textActiveTertiary,
                              fontFamily: 'RegularText'))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: MergeSemantics(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        child: const Text('Overall Rating',
                            style: TextStyle(
                              fontFamily: 'RegularText',
                              fontSize: 14,
                            ))),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                            '${widget.review.averageOverallRating.toStringAsFixed(2)} / 5.0',
                            style: const TextStyle(
                                fontFamily: 'RegularText',
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: MergeSemantics(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        child: const Text('Difficulty Rating',
                            style: TextStyle(
                              fontFamily: 'RegularText',
                              fontSize: 14,
                            ))),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                            '${widget.review.averageDifficultyRating.toStringAsFixed(2)} / 5.0',
                            style: const TextStyle(
                                fontFamily: 'RegularText',
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SfCircularChart(
                    title:
                        const ChartTitle(text: 'Grades Received by Students'),
                    legend: const Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    series: <CircularSeries>[
                      // Render pie chart
                      PieSeries<Map<String, int>, String>(
                        dataLabelMapper: (Map<String, int> data, _) {
                          return '${((data.values.first / widget.review.individualCourseReviews!.length) * 100).toStringAsFixed(2)}%';
                        },
                        radius: '70%',
                        dataSource: widget.review.gradeFrequencyData,
                        xValueMapper: (Map<String, int> data, _) =>
                            data.keys.first,
                        yValueMapper: (Map<String, int> data, _) =>
                            data.values.first,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                            useSeriesColor: true,
                            connectorLineSettings: ConnectorLineSettings(
                                type: ConnectorType.curve)),
                      )
                    ]),
                SfCircularChart(
                    title: const ChartTitle(
                        text: 'Work-hour/week Submitted by Students'),
                    legend: const Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    series: <CircularSeries>[
                      // Render pie chart
                      PieSeries<Map<String, int>, String>(
                        dataLabelMapper: (Map<String, int> data, _) {
                          return '${((data.values.first / widget.review.individualCourseReviews!.length) * 100).toStringAsFixed(2)}%';
                        },
                        radius: '70%',
                        dataSource: widget.review.workloadFrequencyData,
                        xValueMapper: (Map<String, int> data, _) =>
                            data.keys.first,
                        yValueMapper: (Map<String, int> data, _) =>
                            data.values.first,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                            useSeriesColor: true,
                            connectorLineSettings: ConnectorLineSettings(
                                type: ConnectorType.curve)),
                      )
                    ]),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: MergeSemantics(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        child: const Text('Course Tags',
                            style: TextStyle(
                              fontFamily: 'RegularText',
                              fontSize: 14,
                            ))),
                    Container(
                        alignment: Alignment.center,
                        child: Wrap(
                            children:
                                List.generate(widget.review.tags.length, (idx) {
                          return IndexedSemantics(
                              index: idx,
                              child:
                                  TagWidget(tagName: widget.review.tags[idx]));
                        }))),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 8),
              child: Semantics(
                  label: 'Read all reviews for this course',
                  child: TextButton(
                    onPressed: () {
                      appState.changePages('/allreviews',
                          param1: widget.review);
                    },
                    child: const Text('Read all reviews'),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Semantics(
                label: 'Bookmark this course',
                child: ElevatedButton(
                  onPressed: () async {
                    if (isBookmarked) {
                      await widget.bookmarkService.deleteBookmark(
                          widget.firebaseAuth.currentUser!.uid,
                          widget.review.courseReviewId!);
                      setState(() => isBookmarked = false);
                    } else {
                      Bookmark bookmark = Bookmark(
                          courseId: widget.review.courseReviewId!,
                          userId: widget.firebaseAuth.currentUser!.uid);
                      await widget.bookmarkService.addBookmark(bookmark);
                      setState(() => isBookmarked = true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: isBookmarked
                        ? AppColor().buttonInactive
                        : AppColor().darkPurple,
                  ),
                  child: isBookmarked
                      ? const Text(
                          'Un-Bookmark this Course!',
                          textAlign: TextAlign.center,
                        )
                      : const Text(
                          'Bookmark this Course!',
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
