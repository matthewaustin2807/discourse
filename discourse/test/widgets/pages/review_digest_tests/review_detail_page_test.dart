import 'package:discourse/components/reviewdigest/review_card.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/reviewdigest/review_detail_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test all necessary components are present',
      (WidgetTester tester) async {
    CourseReview review = CourseReview(
        courseId: "a",
        instructorId: "b",
        course: Course(
            courseName: 'test course',
            courseNumber: '1234',
            courseId: '123',
            courseDescription: "test",
            externalRating: 2.5,
            externalUrl: 'a'),
        instructor:
            Instructor(firstName: 'john', lastName: 'doe', instructorId: 'abc'),
        averageOverallRating: 3.5,
        averageDifficultyRating: 3.5,
        tags: [
          "tag"
        ],
        workloadFrequency: {
          '10-13': 1,
        },
        workloadFrequencyData: [
          {'10-13': 1},
        ],
        gradeFrequencyData: [
          {'A': 1}
        ],
        gradeFrequency: {
          'A': 1,
        },
        individualCourseReviews: [
          IndividualCourseReview(
              reviewerId: '1',
              reviewerUsername: 'test user',
              courseId: '1',
              instructorId: '1',
              semester: 'fall',
              year: '2024',
              tags: ['tag'],
              estimatedWorkload: '10-13 hrs',
              grade: 'A',
              difficultyRating: 3.5,
              overallRating: 3.5,
              reviewDetail: 'test review')
        ]);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ReviewDetailPage(
              review: review,
              isBookmarked: false,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    // Check if the course information are visible
    expect(find.text('test course'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
    expect(find.text('test'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'By john doe'), findsOneWidget);
    expect(find.text('3.50 stars'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    // Check if the pie charts are visible
    await tester.tap(find.text('Grade and Workload'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Grades Received by Students'), findsOneWidget);

    await tester
        .ensureVisible(find.text('Work-hour/week Submitted by Students'));
    expect(find.byType(SfCircularChart), findsNWidgets(2));

    // Check if the Rating Details are visible
    await tester.ensureVisible(find.text('Rating Detail'));
    await tester.tap(find.text('Rating Detail'));
    await tester.pump();

    expect(find.text('Discourse Rating'), findsOneWidget);
    expect(find.text('Instructor Rating'), findsOneWidget);
    expect(find.text('Difficulty Rating'), findsOneWidget);
    expect(find.text('Rate My Course Rating'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'View external website'), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsNWidgets(4));
    expect(find.byType(Slider), findsOneWidget);

    // Check if the Course Reviews are visible.
    expect(find.text('Course Reviews'), findsOneWidget);
    expect(find.byType(ReviewCard), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Read all reviews'), findsOneWidget);

    // Check if the course tags are visible
    expect(find.text('Course Tags'), findsOneWidget);
    expect(find.widgetWithText(TagWidget, 'tag'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
