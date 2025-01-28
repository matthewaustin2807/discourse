import 'package:discourse/components/reviewdigest/review_card.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test all necessary components', (WidgetTester tester) async {
    IndividualCourseReview individualCourseReview = IndividualCourseReview(
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
        reviewDetail: 'test review');

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ReviewCard(
              individualReview: individualCourseReview,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    // Check if the name, time stamp and rating bar is present
    expect(find.text('test user'), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsOneWidget);
    expect(find.text('fall 2024'), findsOneWidget);

    // Check if the review detail is present
    expect(find.text('test review'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
