import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/reviewdigest/review_card.dart';
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
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Page to show Course Review Details
class ReviewDetailPage extends StatefulWidget {
  const ReviewDetailPage(
      {super.key, required this.review, required this.isBookmarked});
  final CourseReview review;
  final bool isBookmarked;

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  bool _expanded = false;
  bool _bookmarked = false;

  @override
  void initState() {
    super.initState();
    setState(() => _bookmarked = widget.isBookmarked);
  }

  /// Launches an external URL in the device's Browser
  Future<void> _launchUrl(String _url) async {
    Uri uri = Uri.parse(_url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          DiscourseAppBar(parentContext: context, pageName: '', isForm: false),
          Container(
            constraints: BoxConstraints(
              maxWidth: screenSize.width,
              maxHeight: screenSize.height * 0.7,
            ),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColor().separator))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Wrap(
                            children: [
                              Semantics(
                                label:
                                    'Review Detail for ${widget.review.course!.courseName}',
                                child: Text(widget.review.course!.courseName,
                                    style: const TextStyle(
                                        fontFamily: 'RegularText',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            widget.review.course!.courseNumber,
                            style: const TextStyle(
                                fontFamily: 'RegularText', fontSize: 24),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            widget.review.course!.courseDescription,
                            style: TextStyle(
                                fontFamily: 'RegularText',
                                fontSize: 14,
                                color: AppColor().textActiveTertiary),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Row(
                                      children: [
                                        ExcludeSemantics(
                                          child: Icon(Icons.person,
                                              color: AppColor()
                                                  .textActiveTertiary),
                                        ),
                                        Semantics(
                                          label:
                                              'Instructor is ${widget.review.instructor!.firstName} ${widget.review.instructor!.lastName}',
                                          child: TextButton(
                                            onPressed: () {
                                              appState.changePages(
                                                  '/instructordetail',
                                                  param1: widget
                                                      .review.instructorId);
                                            },
                                            child: Text(
                                                'By ${widget.review.instructor!.firstName} ${widget.review.instructor!.lastName}',
                                                style: TextStyle(
                                                    fontFamily: 'RegularText',
                                                    fontSize: 14,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: AppColor()
                                                        .textActiveTertiary)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ExcludeSemantics(
                                        child: Icon(Icons.star,
                                            color:
                                                AppColor().textActiveTertiary),
                                      ),
                                      Semantics(
                                          label:
                                              'Rated ${widget.review.averageOverallRating.toStringAsFixed(2)} stars',
                                          child: Text(
                                              '${widget.review.averageOverallRating.toStringAsFixed(2)} stars',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText',
                                                  fontSize: 14,
                                                  color: AppColor()
                                                      .textActiveTertiary))),
                                    ],
                                  ),
                                ],
                              ),
                              Semantics(
                                  label:
                                      'Bookmark ${widget.review.course!.courseName}',
                                  button: true,
                                  child: IconButton(
                                    onPressed: () async {
                                      if (_bookmarked) {
                                        await BookmarkService().deleteBookmark(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            widget.review.courseReviewId!);
                                        setState(() => _bookmarked = false);
                                      } else {
                                        Bookmark bookmark = Bookmark(
                                            courseId:
                                                widget.review.courseReviewId!,
                                            userId: FirebaseAuth
                                                .instance.currentUser!.uid);
                                        await BookmarkService()
                                            .addBookmark(bookmark);
                                        setState(() => _bookmarked = true);
                                      }
                                    },
                                    icon: _bookmarked
                                        ? Icon(Icons.bookmark,
                                            color: AppColor().darkPurple)
                                        : const Icon(
                                            Icons.bookmark_border,
                                          ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColor().separator))),
                    child: ExpansionTile(
                      expandedAlignment: Alignment.centerLeft,
                      shape: Border(
                          bottom: BorderSide(color: AppColor().separator)),
                      dense: true,
                      tilePadding: const EdgeInsets.only(left: 0),
                      title: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text('Grade and Workload',
                            style: TextStyle(
                                fontFamily: 'RegularText', fontSize: 20)),
                      ),
                      children: [
                        Column(
                          children: [
                            SfCircularChart(
                                title: const ChartTitle(
                                    text: 'Grades Received by Students'),
                                legend: const Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap),
                                series: <CircularSeries>[
                                  // Render pie chart
                                  PieSeries<Map<String, int>, String>(
                                    dataLabelMapper:
                                        (Map<String, int> data, _) {
                                      return '${((data.values.first / widget.review.individualCourseReviews!.length) * 100).toStringAsFixed(2)}%';
                                    },
                                    radius: '50%',
                                    dataSource:
                                        widget.review.gradeFrequencyData,
                                    xValueMapper: (Map<String, int> data, _) =>
                                        data.keys.first,
                                    yValueMapper: (Map<String, int> data, _) =>
                                        data.values.first,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        labelPosition:
                                            ChartDataLabelPosition.outside,
                                        useSeriesColor: true,
                                        connectorLineSettings:
                                            ConnectorLineSettings(
                                                type: ConnectorType.curve)),
                                  )
                                ]),
                            SfCircularChart(
                                title: const ChartTitle(
                                    text:
                                        'Work-hour/week Submitted by Students'),
                                legend: const Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap),
                                series: <CircularSeries>[
                                  // Render pie chart
                                  PieSeries<Map<String, int>, String>(
                                    dataLabelMapper:
                                        (Map<String, int> data, _) {
                                      return '${((data.values.first / widget.review.individualCourseReviews!.length) * 100).toStringAsFixed(2)}%';
                                    },
                                    radius: '50%',
                                    dataSource:
                                        widget.review.workloadFrequencyData,
                                    xValueMapper: (Map<String, int> data, _) =>
                                        data.keys.first,
                                    yValueMapper: (Map<String, int> data, _) =>
                                        data.values.first,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        labelPosition:
                                            ChartDataLabelPosition.outside,
                                        useSeriesColor: true,
                                        connectorLineSettings:
                                            ConnectorLineSettings(
                                                type: ConnectorType.curve)),
                                  )
                                ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColor().separator))),
                    child: Semantics(
                      expanded: _expanded,
                      onTapHint: 'See all Rating Details',
                      child: ExpansionTile(
                        onExpansionChanged: (expanded) {
                          setState(() => _expanded = expanded);
                        },
                        tilePadding: const EdgeInsets.only(left: 0),
                        expandedAlignment: Alignment.centerLeft,
                        dense: true,
                        shape: Border(
                            bottom: BorderSide(color: AppColor().separator)),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Rating Detail',
                              style: TextStyle(
                                  fontFamily: 'RegularText', fontSize: 20)),
                        ),
                        children: [
                          MergeSemantics(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: const Text('Discourse Rating',
                                        style: TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 16)),
                                  ),
                                  Container(
                                    child: Semantics(
                                      label:
                                          '${widget.review.averageOverallRating} stars',
                                      child: RatingBarIndicator(
                                        itemBuilder: (context, idx) {
                                          return Icon(Icons.star,
                                              color:
                                                  AppColor().starColorPrimary);
                                        },
                                        itemCount: 5,
                                        itemSize: 18,
                                        rating:
                                            widget.review.averageOverallRating,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MergeSemantics(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: const Text('Instructor Rating',
                                        style: TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 16)),
                                  ),
                                  Container(
                                    child: Semantics(
                                      label:
                                          '${widget.review.averageOverallRating} stars',
                                      child: RatingBarIndicator(
                                        itemBuilder: (context, idx) {
                                          return Icon(Icons.star,
                                              color:
                                                  AppColor().starColorPrimary);
                                        },
                                        itemCount: 5,
                                        itemSize: 18,
                                        rating:
                                            widget.review.averageOverallRating,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MergeSemantics(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Difficulty Rating',
                                      style: TextStyle(
                                        fontFamily: 'RegularText',
                                        fontSize: 16,
                                      )),
                                  Semantics(
                                    label:
                                        '${widget.review.averageDifficultyRating} out of 5',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Easy',
                                            style: TextStyle(
                                                fontFamily: 'RegularText')),
                                        Slider(
                                          divisions: 8,
                                          label: widget
                                              .review.averageDifficultyRating
                                              .toString(),
                                          value: widget
                                              .review.averageDifficultyRating,
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
                          MergeSemantics(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: const Text('Rate My Course Rating',
                                        style: TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 16)),
                                  ),
                                  Container(
                                    child: Semantics(
                                      label: widget.review.course!
                                                  .externalRating !=
                                              0
                                          ? '${widget.review.course!.externalRating} stars'
                                          : 'No rating',
                                      child: widget.review.course!
                                                  .externalRating !=
                                              0
                                          ? RatingBarIndicator(
                                              itemBuilder: (context, idx) {
                                                return Icon(Icons.star,
                                                    color: AppColor()
                                                        .starColorPrimary);
                                              },
                                              itemCount: 5,
                                              itemSize: 18,
                                              rating: widget.review.course!
                                                  .externalRating!,
                                            )
                                          : const Text("N/A"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: widget.review.course!.externalUrl!.isEmpty
                                ? const SizedBox.shrink()
                                : TextButton(
                                    onPressed: () =>
                                        _launchUrl(widget.review.course!.externalUrl!),
                                    child: const Text('View external website'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColor().separator)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: const Text('Course Reviews',
                                style: TextStyle(
                                    fontFamily: 'RegularText', fontSize: 20))),
                        ReviewCard(
                          showSeparator: false,
                          individualReview:
                              widget.review.individualCourseReviews![0],
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(top: 8),
                          child: Semantics(
                            label: 'Read all reviews for this course',
                            button: true,
                            child: TextButton(
                              onPressed: () {
                                appState.changePages(
                                  '/allreviews',
                                  param1: widget.review,
                                );
                              },
                              child: const Text('Read all reviews'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Semantics(
                            label: 'List of Tags associated with this review',
                            excludeSemantics: true,
                            child: const Text('Course Tags',
                                style: TextStyle(
                                    fontFamily: 'RegularText', fontSize: 20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            children:
                                List.generate(widget.review.tags.length, (idx) {
                              return IndexedSemantics(
                                  index: idx,
                                  child: TagWidget(
                                    tagName: widget.review.tags[idx],
                                  ));
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
