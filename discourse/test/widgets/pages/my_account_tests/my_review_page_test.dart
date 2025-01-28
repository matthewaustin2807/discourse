import 'package:discourse/components/myaccount/my_review_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/myaccounts/my_reviews_page.dart';
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

  testWidgets('Test if My Review Page renders properly',
      (WidgetTester tester) async {
    MockCourseReviewService mockCourseReviewService = MockCourseReviewService();
    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    List<IndividualCourseReview> myReviews = [
      IndividualCourseReview(
          reviewerId: '1',
          reviewerUsername: 'test user',
          courseId: '1',
          course: Course(
              courseName: 'a', courseDescription: 'b', courseNumber: '1'),
          instructorId: '1',
          instructor: Instructor(firstName: 'test', lastName: 'name'),
          semester: 'fall',
          year: '2024',
          tags: ['tag'],
          estimatedWorkload: '10-13 hrs',
          grade: 'A',
          difficultyRating: 3.5,
          overallRating: 3.5,
          reviewDetail: 'test review')
    ];

    List<Course> myExistingCourseNames = [
      Course(courseName: 'a', courseDescription: 'b', courseNumber: '1'),
    ];

    when(mockCourseReviewService.getMyReviews(user.uid))
        .thenAnswer((_) async => myReviews);
    when(mockCourseReviewService.getAllExistingMyReviews(user.uid))
        .thenAnswer((_) async => myExistingCourseNames);
    when(mockCourseReviewService.getMyReviewsFiltered('a', user.uid))
        .thenAnswer((_) async => myReviews);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MyReviewPage(
              courseReviewService: mockCourseReviewService,
              firebaseAuth: auth,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('My Reviews'), findsOneWidget);
    expect(find.byType(SearchModule<Course>), findsOneWidget);
    expect(find.byType(MyReviewCard), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test if the search bar is functional',
      (WidgetTester tester) async {
    MockCourseReviewService mockCourseReviewService = MockCourseReviewService();
    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    List<IndividualCourseReview> myReviews = [
      IndividualCourseReview(
          reviewerId: '1',
          reviewerUsername: 'test user',
          courseId: '1',
          course: Course(
              courseName: 'a', courseDescription: 'b', courseNumber: '1'),
          instructorId: '1',
          instructor: Instructor(firstName: 'test', lastName: 'name'),
          semester: 'fall',
          year: '2024',
          tags: ['tag'],
          estimatedWorkload: '10-13 hrs',
          grade: 'A',
          difficultyRating: 3.5,
          overallRating: 3.5,
          reviewDetail: 'test review'),
      IndividualCourseReview(
          reviewerId: '1',
          reviewerUsername: 'test user',
          courseId: '2',
          course: Course(
              courseName: 'b', courseDescription: 'b', courseNumber: '2'),
          instructorId: '1',
          instructor: Instructor(firstName: 'test', lastName: 'name'),
          semester: 'fall',
          year: '2024',
          tags: ['tag'],
          estimatedWorkload: '10-13 hrs',
          grade: 'A',
          difficultyRating: 3.5,
          overallRating: 3.5,
          reviewDetail: 'test review')
    ];

    List<IndividualCourseReview> searchResult = [
      IndividualCourseReview(
          reviewerId: '1',
          reviewerUsername: 'test user',
          courseId: '1',
          course: Course(
              courseName: 'a', courseDescription: 'b', courseNumber: '1'),
          instructorId: '1',
          instructor: Instructor(firstName: 'test', lastName: 'name'),
          semester: 'fall',
          year: '2024',
          tags: ['tag'],
          estimatedWorkload: '10-13 hrs',
          grade: 'A',
          difficultyRating: 3.5,
          overallRating: 3.5,
          reviewDetail: 'test review'),
    ];

    List<Course> myExistingCourseNames = [
      Course(courseName: 'a', courseDescription: 'b', courseNumber: '1'),
      Course(courseName: 'b', courseDescription: 'b', courseNumber: '2'),
    ];

    when(mockCourseReviewService.getMyReviews(user.uid))
        .thenAnswer((_) async => myReviews);
    when(mockCourseReviewService.getAllExistingMyReviews(user.uid))
        .thenAnswer((_) async => myExistingCourseNames);
    when(mockCourseReviewService.getMyReviewsFiltered('a', user.uid))
        .thenAnswer((_) async => searchResult);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MyReviewPage(
              courseReviewService: mockCourseReviewService,
              firebaseAuth: auth,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(MyReviewCard), findsNWidgets(2));

    await tester.tap(find.byType(SearchModule<Course>));
    await tester.pump();

    expect(
        find.descendant(
            of: find.byType(KeyedSubtree), matching: find.text('1: a')),
        findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byType(KeyedSubtree), matching: find.text('1: a')));
    await tester.pump();
    await tester.pump();

    expect(find.byType(MyReviewCard), findsOneWidget);

    await tester.tap(find.descendant(
        of: find.byType(SearchModule<Course>), matching: find.byType(Icon)));
    await tester.pump();
    await tester.pump();

    expect(find.byType(MyReviewCard), findsNWidgets(2));
  });
}
