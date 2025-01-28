import 'package:discourse/components/home_page_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/pages/home_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import '../review_digest_tests/mocks/selecting_compare_page_test.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Test if the search bar and grid item is present',
      (WidgetTester tester) async {
    final mockCourseReviewService = MockCourseReviewService();
    List<Course> mockCourses = [
      Course(
          courseName: 'test course',
          courseNumber: '1234',
          courseId: '123',
          courseDescription: "test"),
    ];
    when(mockCourseReviewService.getAllExistingReviews())
        .thenAnswer((_) async => mockCourses);

    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: HomePage(
              firebaseAuth: auth,
              courseReviewService: mockCourseReviewService,
            ),
          ),
        ),
      ),
    );
    await tester.pump(Durations.long1);
    expect(find.text('Discourse'), findsOneWidget);

    expect(find.byType(HomePageCard), findsNWidgets(2));

    expect(find.byType(SearchModule<Course>), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets(
      'Test if user is prompted to enter their display name if its not set',
      (WidgetTester tester) async {
    final mockCourseReviewService = MockCourseReviewService();
    List<Course> mockCourses = [
      Course(
          courseName: 'test course',
          courseNumber: '1234',
          courseId: '123',
          courseDescription: "test"),
    ];
    when(mockCourseReviewService.getAllExistingReviews())
        .thenAnswer((_) async => mockCourses);

    final user = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'test@gmail.com',
    );
    final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: HomePage(
              firebaseAuth: auth,
              courseReviewService: mockCourseReviewService,
            ),
          ),
        ),
      ),
    );
    await tester.pump(Durations.long1);
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(
        find.descendant(
            of: find.byType(AlertDialog), matching: find.byType(TextField)),
        'test name');
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pump();
  });
}
