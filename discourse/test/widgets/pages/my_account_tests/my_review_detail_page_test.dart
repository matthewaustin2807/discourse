import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/myaccounts/my_review_detail_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets(
      'Test if My Review Detail page shows the necessary information at render',
      (WidgetTester tester) async {
    IndividualCourseReview individualCourseReview = IndividualCourseReview(
        reviewerId: '1',
        reviewerUsername: 'test user',
        courseId: '1',
        course:
            Course(courseName: 'a', courseDescription: 'b', courseNumber: '1'),
        instructorId: '1',
        instructor: Instructor(firstName: 'test', lastName: 'name'),
        semester: 'fall',
        year: '2024',
        tags: ['tag'],
        estimatedWorkload: '10-13 hrs',
        grade: 'A',
        difficultyRating: 3.5,
        overallRating: 3.5,
        reviewDetail: 'test review');

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MyReviewDetailPage(
              review: individualCourseReview,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('a'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    expect(find.text('My Ratings'), findsOneWidget);
    expect(find.text('Overall Rating'), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsOneWidget);
    expect(find.text('Difficulty Rating'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);

    expect(find.text('Taken'), findsOneWidget);
    expect(find.text('fall 2024'), findsOneWidget);

    expect(find.text('Instructor'), findsOneWidget);
    expect(find.text('test name'), findsOneWidget);

    expect(find.text('Grade'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);

    expect(find.text('Work/week'), findsOneWidget);
    expect(find.text('10-13 hrs'), findsOneWidget);

    expect(find.text('Course Tags'), findsOneWidget);
    expect(find.widgetWithText(TagWidget, 'tag'), findsOneWidget);

    expect(find.text('My Detailed Review'), findsOneWidget);
    expect(find.text('test review'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
