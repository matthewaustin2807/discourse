import 'package:discourse/components/reviewdigest/compared_review_column.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/reviewdigest/comparison_result_page.dart';
import 'package:discourse/service/bookmark_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import 'mocks/comparison_result_page_test.mocks.dart';

@GenerateMocks([BookmarkService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Test the presence of necessary components',
      (WidgetTester tester) async {
    MockBookmarkService mockBookmarkService = MockBookmarkService();

    CourseReview firstCourse = CourseReview(
        courseReviewId: '123',
        courseId: "a",
        instructorId: "1",
        course: Course(
            courseName: 'test course 1',
            courseNumber: '123',
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
        },
        workloadFrequencyData: [
          {'10-13': 1},
        ],
        gradeFrequencyData: [
          {'A': 1}
        ],
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

    CourseReview secondCourse = CourseReview(
        courseReviewId: 'abc',
        courseId: "b",
        instructorId: "2",
        course: Course(
            courseName: 'test course 2',
            courseNumber: '1234',
            courseId: '123',
            courseDescription: "test"),
        instructor:
            Instructor(firstName: 'jane', lastName: 'doe', instructorId: 'abc'),
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
        },
        workloadFrequencyData: [
          {'10-13': 1},
        ],
        gradeFrequencyData: [
          {'A': 1}
        ],
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

    when(mockBookmarkService.isBookmarked(user.uid, firstCourse.courseReviewId))
        .thenAnswer((_) async => false);
    when(mockBookmarkService.isBookmarked(
            user.uid, secondCourse.courseReviewId))
        .thenAnswer((_) async => false);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ComparisonResultPage(
              firstCourse: firstCourse,
              secondCourse: secondCourse,
              firebaseAuth: auth,
              bookmarkService: mockBookmarkService,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(ComparedReviewColumn), findsNWidgets(2));

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
