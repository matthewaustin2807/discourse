import 'package:discourse/components/reviewdigest/review_card.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/reviewdigest/all_review_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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
            courseDescription: "test"),
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
            body: AllReviewPage(courseReview: review),
          ),
        ),
      ),
    );

    await tester.pump();

    // Check if the course information is present
    expect(find.text('test course'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
    expect(find.text('By john doe'), findsOneWidget);
    expect(find.text('3.50 stars'), findsOneWidget);

    expect(find.byType(ReviewCard), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
