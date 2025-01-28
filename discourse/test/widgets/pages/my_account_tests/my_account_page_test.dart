import 'package:discourse/components/myaccount/compact_bookmark_card.dart';
import 'package:discourse/components/myaccount/compact_review_card.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/myaccounts/my_account_page.dart';
import 'package:discourse/service/upload_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import '../review_digest_tests/mocks/review_digest_page_test.mocks.dart';
import 'mocks/my_account_page_test.mocks.dart';

@GenerateMocks([FileUploadService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets(
      'Test all widgets are loaded when page is built without MyReview and MyBookmarks',
      (WidgetTester tester) async {
    MockFileUploadService mockFileUploadService = MockFileUploadService();

    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    List<IndividualCourseReview> myReviews = [];
    List<CourseReview> myBookmarks = [];

    MockCourseReviewService mockCourseReviewService = MockCourseReviewService();
    when(mockCourseReviewService.getMyReviews(user.uid))
        .thenAnswer((_) async => myReviews);
    when(mockCourseReviewService.getMyBookmarks(user.uid))
        .thenAnswer((_) async => myBookmarks);

    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
          child: MaterialApp(
            home: Scaffold(
              body: MyAccount(
                courseReviewService: mockCourseReviewService,
                fileUploadService: mockFileUploadService,
                firebaseAuth: auth,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('My Account'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(
          find.widgetWithText(TextButton, 'Edit Display Name'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'My Reviews'), findsOneWidget);
      expect(
          find.text('Your reviewed courses will appear here'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'My Bookmarks'), findsOneWidget);
      expect(find.text('Bookmarked courses will appear here'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  testWidgets(
      'Test my review card and my bookmark card shows up if user has at least one review and bookmark',
      (WidgetTester tester) async {
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
    List<CourseReview> myBookmarks = [
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

    MockFileUploadService mockFileUploadService = MockFileUploadService();
    MockCourseReviewService mockCourseReviewService = MockCourseReviewService();
    when(mockCourseReviewService.getMyReviews(user.uid))
        .thenAnswer((_) async => myReviews);
    when(mockCourseReviewService.getMyBookmarks(user.uid))
        .thenAnswer((_) async => myBookmarks);

    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
          child: MaterialApp(
            home: Scaffold(
              body: MyAccount(
                courseReviewService: mockCourseReviewService,
                fileUploadService: mockFileUploadService,
                firebaseAuth: auth,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CompactReviewCard), findsOneWidget);
      expect(find.byType(CompactBookmarkCard), findsOneWidget);
    });
  });

  testWidgets('Test editing display name', (WidgetTester tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
    MockFileUploadService mockFileUploadService = MockFileUploadService();
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
    List<CourseReview> myBookmarks = [
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
    when(mockCourseReviewService.getMyReviews(user.uid))
        .thenAnswer((_) async => myReviews);
    when(mockCourseReviewService.getMyBookmarks(user.uid))
        .thenAnswer((_) async => myBookmarks);

    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
          child: MaterialApp(
            home: Scaffold(
              body: MyAccount(
                courseReviewService: mockCourseReviewService,
                fileUploadService: mockFileUploadService,
                firebaseAuth: auth,
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.widgetWithText(TextButton, 'Edit Display Name'));
      await tester.pump();

      expect(find.text('Edit your Display Name'), findsOneWidget);
      await tester.enterText(
          find.widgetWithText(TextField, 'Enter your new name'), 'New Name');
      await tester.pump();

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pump();

      await tester.tap(find.widgetWithText(TextButton, 'Edit Display Name'));
      await tester.pump();

      await tester.enterText(
          find.widgetWithText(TextField, 'Enter your new name'), 'New Name');
      await tester.pump();

      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pump();

      // Ensure the displayed name is changed.
      expect(find.text('New Name'), findsOneWidget);
    });
  });
}
