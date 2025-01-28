import 'package:discourse/components/myaccount/my_bookmark_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/myaccounts/my_bookmarks_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import '../review_digest_tests/mocks/review_digest_page_test.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets(
      'Test if My Bookmark page renders properly and search bar functions well',
      (WidgetTester tester) async {
    MockCourseReviewService mockCourseReviewService = MockCourseReviewService();
    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    List<CourseReview> myBookmarks = [
      CourseReview(
          courseId: "a",
          instructorId: "b",
          course: Course(
              courseName: 'test course 1',
              courseNumber: '1234',
              courseId: '123',
              courseDescription: "test"),
          instructor: Instructor(
              firstName: 'john', lastName: 'doe', instructorId: 'abc'),
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
          }),
      CourseReview(
          courseId: "a",
          instructorId: "b",
          course: Course(
              courseName: 'test course 2',
              courseNumber: '12345',
              courseId: '124',
              courseDescription: "test"),
          instructor: Instructor(
              firstName: 'john', lastName: 'doe', instructorId: 'abc'),
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
          })
    ];

    List<CourseReview> searchResults = [
      CourseReview(
          courseId: "a",
          instructorId: "b",
          course: Course(
              courseName: 'test course 1',
              courseNumber: '1234',
              courseId: '123',
              courseDescription: "test"),
          instructor: Instructor(
              firstName: 'john', lastName: 'doe', instructorId: 'abc'),
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
          }),
    ];

    List<Course> myExistingCourseNames = [
      Course(
          courseName: 'test course 1',
          courseNumber: '1234',
          courseId: '123',
          courseDescription: "test"),
      Course(
          courseName: 'test course 2',
          courseNumber: '1234',
          courseId: '124',
          courseDescription: "test"),
    ];

    when(mockCourseReviewService.getMyBookmarks(user.uid))
        .thenAnswer((_) async => myBookmarks);
    when(mockCourseReviewService.getAllCourseNamesFromMyBookmarks(user.uid))
        .thenAnswer((_) async => myExistingCourseNames);
    when(mockCourseReviewService.getMyBookmarksFilteredByCourse(
            user.uid, myBookmarks[0].course!.courseName))
        .thenAnswer((_) async => searchResults);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MyBookmarksPage(
              courseReviewService: mockCourseReviewService,
              firebaseAuth: auth,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('My Bookmarks'), findsOneWidget);
    expect(find.byType(SearchModule<Course>), findsOneWidget);
    expect(find.byType(MyBookmarkCard), findsNWidgets(2));

    await tester.tap(find.byType(SearchModule<Course>));
    await tester.pump();

    expect(
        find.descendant(
            of: find.byType(KeyedSubtree),
            matching: find.text('1234: test course 1')),
        findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byType(KeyedSubtree),
        matching: find.text('1234: test course 1')));
    await tester.pump();
    await tester.pump();

    expect(find.byType(MyBookmarkCard), findsOneWidget);

    await tester.tap(find.descendant(
        of: find.byType(SearchModule<Course>), matching: find.byType(Icon)));
    await tester.pump();
    await tester.pump();

    expect(find.byType(MyBookmarkCard), findsNWidgets(2));

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
