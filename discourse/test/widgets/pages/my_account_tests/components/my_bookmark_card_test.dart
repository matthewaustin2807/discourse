import 'package:discourse/components/myaccount/my_bookmark_card.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/instructor.dart';
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

  testWidgets(
      'Test if the Bookmark card shows the necessary information at render',
      (WidgetTester tester) async {
    CourseReview courseReview = CourseReview(
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
        gradeFrequency: {
          'A': 1,
        });

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MyBookmarkCard(
              bookmark: courseReview,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('test course'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
    expect(find.text('By: john doe'), findsOneWidget);
    expect(find.text('Overall Rating'), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsOneWidget);
    expect(find.widgetWithText(TagWidget, 'tag'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
