import 'package:discourse/components/reviewdigest/review_digest_card.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../firebase_test_mock.dart';
import '../mocks/comparison_result_page_test.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test all necessary components', (WidgetTester tester) async {
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
        gradeFrequency: {
          'A': 1,
        });

    List<Bookmark> bookmarks = [
      Bookmark(courseId: '1', userId: '1'),
    ];

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
            body: ReviewDigestCard(
              review: review,
              bookmarks: bookmarks,
              bookmarkService: mockBookmarkService,
              firebaseAuth: auth,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('test course'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
    expect(find.text('By: john doe'), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsOneWidget);
    expect(find.widgetWithText(TagWidget, 'tag'), findsOneWidget);

    // Press the bookmark button and check if it changes accordingly.
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // Check if the compare button is present
    expect(find.widgetWithText(ElevatedButton, 'Compare'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test compare mode', (WidgetTester tester) async {
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
        gradeFrequency: {
          'A': 1,
        });
    List<Bookmark> bookmarks = [
      Bookmark(courseId: '123', userId: '1'),
    ];

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
            body: ReviewDigestCard(
              review: review,
              inCompare: true,
              bookmarks: bookmarks,
              firebaseAuth: auth,
              bookmarkService: mockBookmarkService,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('test course'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
    expect(find.text('By: john doe'), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsOneWidget);
    expect(find.widgetWithText(TagWidget, 'tag'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsNothing);
    expect(find.widgetWithText(ElevatedButton, 'Compare'), findsNothing);
  });
}
