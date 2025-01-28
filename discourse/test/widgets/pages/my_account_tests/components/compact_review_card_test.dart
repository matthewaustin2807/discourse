import 'package:discourse/components/myaccount/compact_review_card.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test if the Compact My Review Card widget renders properly',
      (WidgetTester tester) async {
    IndividualCourseReview individualCourseReview = IndividualCourseReview(
        reviewerId: '1',
        reviewerUsername: 'test user',
        courseId: '1',
        course: Course(
            courseName: 'test course',
            courseDescription: 'test description',
            courseNumber: '1'),
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
            body: CompactReviewCard(
              review: individualCourseReview,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('test course'), findsOneWidget);
    expect(find.text('test review'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
