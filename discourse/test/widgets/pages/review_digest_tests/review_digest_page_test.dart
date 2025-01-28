import 'package:discourse/components/reviewdigest/review_digest_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/reviewdigest/review_digest.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import '../write_review_tests/mocks/write_review_page_test.mocks.dart';
import 'mocks/comparison_result_page_test.mocks.dart';
import 'mocks/review_digest_page_test.mocks.dart';

@GenerateMocks([CourseReviewService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test all necessary components are present',
      (WidgetTester tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
    List<CourseReview> courseReviews = [
      CourseReview(
          courseId: "a",
          instructorId: "b",
          course: Course(
              courseName: 'test course',
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
          })
    ];

    MockCourseReviewService mockCourseReviewService = MockCourseReviewService();
    when(mockCourseReviewService.getAllCoursesForDigest())
        .thenAnswer((_) async => courseReviews);
    when(mockCourseReviewService.getAllCoursesFilteredByInstructor('john doe',
            forCompare: false, currentCourseReviewId: null))
        .thenAnswer((_) async => courseReviews);
    when(mockCourseReviewService.getAllCoursesFilteredByCourse('test course',
            forCompare: false, currentCourseReviewId: null))
        .thenAnswer((_) async => courseReviews);

    final mockCourseService = MockCourseService();
    List<Course> mockCourses = [
      Course(
          courseName: 'test course',
          courseNumber: '1234',
          courseId: '123',
          courseDescription: "test"),
    ];
    when(mockCourseService.getAllCourse()).thenAnswer((_) async => mockCourses);

    List<Instructor> mockInstructors = [
      Instructor(firstName: 'john', lastName: 'doe', instructorId: 'abc'),
    ];

    MockInstructorService mockInstructorService = MockInstructorService();
    when(mockInstructorService.getAllInstructors())
        .thenAnswer((_) async => mockInstructors);

    List<Bookmark> bookmarks = [];
    MockBookmarkService mockBookmarkService = MockBookmarkService();
    when(mockBookmarkService.getBookmarksByUser(user.uid))
        .thenAnswer((_) async => bookmarks);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ReviewDigest(
              courseService: mockCourseService,
              instructorService: mockInstructorService,
              courseReviewService: mockCourseReviewService,
              bookmarkService: mockBookmarkService,
              firebaseAuth: auth,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    // Ensure page is loaded
    expect(find.text('Review Digest'), findsOneWidget);

    // Ensure search bar is present and try searching for a course
    expect(find.byType(SearchModule<Course>), findsOneWidget);

    await tester.tap(find.byType(SearchModule<Course>));
    await tester.pump();

    expect(
        find.descendant(
            of: find.byType(KeyedSubtree),
            matching: find.text('1234: test course')),
        findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byType(KeyedSubtree),
        matching: find.text('1234: test course')));
    await tester.pump();

    await tester.tap(find.descendant(
        of: find.byType(SearchModule<Course>), matching: find.byType(Icon)));
    await tester.pump();

    // Ensure we can switch to instructor search mode and try searching for an instructor
    await tester.tap(find.text('Instructor'));
    await tester.pump();

    expect(find.byType(SearchModule<Instructor>), findsOneWidget);

    await tester.tap(find.byType(SearchModule<Instructor>));
    await tester.pump();

    expect(
        find.descendant(
            of: find.byType(KeyedSubtree), matching: find.text('john doe')),
        findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byType(KeyedSubtree), matching: find.text('john doe')));
    await tester.pump();

    await tester.tap(find.descendant(
        of: find.byType(SearchModule<Instructor>),
        matching: find.byType(Icon)));

    expect(find.byType(ReviewDigestCard), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test message if no review is present',
      (WidgetTester tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    List<CourseReview> emptyCourseReviews = [];

    MockCourseReviewService mockCourseReviewService = MockCourseReviewService();
    when(mockCourseReviewService.getAllCoursesForDigest())
        .thenAnswer((_) async => emptyCourseReviews);

    final mockCourseService = MockCourseService();
    List<Course> mockCourses = [
      Course(
          courseName: 'test course',
          courseNumber: '1234',
          courseId: '123',
          courseDescription: "test"),
    ];
    when(mockCourseService.getAllCourse()).thenAnswer((_) async => mockCourses);

    List<Instructor> mockInstructors = [
      Instructor(firstName: 'john', lastName: 'doe', instructorId: 'abc'),
    ];

    MockInstructorService mockInstructorService = MockInstructorService();
    when(mockInstructorService.getAllInstructors())
        .thenAnswer((_) async => mockInstructors);

    List<Bookmark> bookmarks = [];
    MockBookmarkService mockBookmarkService = MockBookmarkService();
    when(mockBookmarkService.getBookmarksByUser(user.uid))
        .thenAnswer((_) async => bookmarks);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ReviewDigest(
              courseService: mockCourseService,
              instructorService: mockInstructorService,
              courseReviewService: mockCourseReviewService,
              bookmarkService: mockBookmarkService,
              firebaseAuth: auth,
            ),
          ),
        ),
      ),
    );

    await tester.pump(Durations.long2);

    expect(find.text('No Reviews To Display'), findsOneWidget);
  });
}
