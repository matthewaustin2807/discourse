import 'package:discourse/components/reviewdigest/review_card.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/reviewdigest/instructor_page.dart';
import 'package:discourse/service/instructor_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import '../write_review_tests/mocks/write_review_page_test.mocks.dart';

@GenerateMocks([InstructorService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Test all components are loaded', (WidgetTester tester) async {
    Instructor testInstructor = Instructor(
        firstName: 'first',
        lastName: 'last',
        externalRating: 2.5,
        externalUrl: 'https://testurl.com',
        averageCourseRating: 2.5,
        averageDifficultyRating: 2.5,
        courseReviewsForInstructor: [
          IndividualCourseReview(
              reviewerId: '1',
              reviewerUsername: 'test user',
              courseId: '1',
              course: Course(courseName: 'a', courseNumber: 'b', courseDescription: 'c'),
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

    MockInstructorService mockInstructorService = MockInstructorService();
    when(mockInstructorService.getInstructorDetails('a'))
        .thenAnswer((_) async => testInstructor);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: InstructorPage(
              instructorId: 'a',
              instructorService: mockInstructorService,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('first last'), findsOneWidget);
    expect(find.text('2.5 Stars'), findsOneWidget);
    expect(find.text('2.5 Difficulty Rating'), findsOneWidget);

    expect(find.byType(ExpansionTile), findsNWidgets(2));

    expect(find.text('Discourse Rating'), findsOneWidget);
    expect(find.text('Difficulty Rating'), findsOneWidget);
    expect(find.text('Rate My Professor Rating'), findsOneWidget);
    expect(find.byType(RatingBarIndicator), findsNWidgets(3));
    expect(find.byType(Slider), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'View external website'), findsOneWidget);

    expect(find.byType(ReviewCard), findsOneWidget);

  });
}
