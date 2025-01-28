import 'package:discourse/components/reviewdigest/compared_review_column.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../firebase_test_mock.dart';
import '../mocks/comparison_result_page_test.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets(
      'Test if all information is visible to the user upon page loading',
      (WidgetTester tester) async {
    CourseReview review = CourseReview(
        courseReviewId: '1',
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

    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    MockBookmarkService mockBookmarkService = MockBookmarkService();
    when(mockBookmarkService.addBookmark(
            Bookmark(userId: user.uid, courseId: review.courseReviewId!)))
        .thenAnswer((_) async => Future<void>);
    when(mockBookmarkService.deleteBookmark(user.uid, review.courseReviewId!))
        .thenAnswer((_) async => Future<void>);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ComparedReviewColumn(
              review: review,
              isBookmarked: false,
              bookmarkService: mockBookmarkService,
              firebaseAuth: auth,
            ),
          ),
        ),
      ),
    );

    await tester.pump(Durations.long1);

    expect(find.text('test course'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
    expect(find.text('By john doe'), findsOneWidget);

    expect(find.text('Overall Rating'), findsOneWidget);
    expect(find.text('Difficulty Rating'), findsOneWidget);
    expect(find.text('3.50 / 5.0'), findsNWidgets(2));

    expect(find.text('Grades Received by Students'), findsOneWidget);
    expect(find.text('Work-hour/week Submitted by Students'), findsOneWidget);
    expect(find.byType(SfCircularChart), findsNWidgets(2));

    await tester.ensureVisible(find.text('Course Tags'));
    expect(find.text('Course Tags'), findsOneWidget);
    expect(find.widgetWithText(TagWidget, 'tag'), findsOneWidget);

    expect(find.widgetWithText(TextButton, 'Read all reviews'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Bookmark this Course!'),
        findsOneWidget);

    await tester
        .tap(find.widgetWithText(ElevatedButton, 'Bookmark this Course!'));
    await tester.pump();

    expect(find.widgetWithText(ElevatedButton, 'Un-Bookmark this Course!'),
        findsOneWidget);

    await tester
        .tap(find.widgetWithText(ElevatedButton, 'Un-Bookmark this Course!'));
    await tester.pump();

    expect(find.widgetWithText(ElevatedButton, 'Bookmark this Course!'),
        findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
