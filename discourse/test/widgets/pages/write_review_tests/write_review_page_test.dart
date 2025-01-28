import 'package:discourse/service/instructor_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:discourse/model/course.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/pages/writereview/write_review_page.dart';
import 'package:discourse/service/course_service.dart';
import 'package:discourse/state/application_state.dart';

import 'mocks/write_review_page_test.mocks.dart';
import '../firebase_test_mock.dart';

@GenerateMocks([CourseService, InstructorService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test the presence of all necessary components',
      (WidgetTester tester) async {
    // Create the test environment, wrapping ApplicationState with ChangeNotifierProvider
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: WriteReviewPage(
              courseService: CourseService(),
              instructorService: InstructorService(),
            ),
          ),
        ),
      ),
    );

    // Verify if the page title exists
    expect(find.text('Write a Review'), findsOneWidget);

    expect(find.text('Search for a course to review'), findsOneWidget);
    expect(find.byType(SearchableDropdown<Course>), findsOneWidget);

    expect(find.text('Who did you take this course with?'), findsOneWidget);
    expect(find.byType(SearchableDropdown<Instructor>), findsOneWidget);

    expect(find.text('When did you take this course?'), findsOneWidget);
    expect(find.text('Estimated Workload/Week'), findsOneWidget);
    expect(find.text('Grade Received'), findsOneWidget);
    expect(find.byType(SearchableDropdown<String>), findsNWidgets(4));

    expect(find.text('Difficulty Rating:'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);

    expect(find.text('+ Add tags for this course'), findsOneWidget);
    expect(find.byType(ActionChip), findsOneWidget);

    expect(find.text('Overall Course Rating:'), findsOneWidget);
    expect(find.byType(RatingBar), findsOneWidget);

    expect(find.text('Write your reviews and thoughts about the course here:'),
        findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    expect(find.text('Submit!'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test inputting data into forms', (WidgetTester tester) async {
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

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: WriteReviewPage(
              courseService: mockCourseService,
              instructorService: mockInstructorService,
            ),
          ),
        ),
      ),
    );
    // Wait until the page loads.
    await tester.ensureVisible(find.text('Write a Review'));

    // Test searching for course
    await tester.tap(find.text('Search for a course'));
    await tester.pump();
    await tester.tap(find.text('1234: test course'));
    await tester.pump();
    expect(find.text('1234: test course'), findsOneWidget);

    // Test selecting semester and year
    await tester.tap(find.text('Search a semester'));
    await tester.pump();
    await tester.tap(find.text('Fall'));
    await tester.pump();

    await tester.tap(find.text('Select a year'));
    await tester.pump();
    await tester.tap(find.text('2024'));
    await tester.pump();

    expect(find.text('Fall'), findsOneWidget);
    expect(find.text('2024'), findsOneWidget);

    // Test searching for instructor
    await tester.tap(find.text('Select an instructor'));
    await tester.pump();

    await tester.tap(find.text('john doe'));
    await tester.pump();

    expect(find.text('john doe'), findsOneWidget);

    // Test choosing workload
    await tester.tap(find.text('Choose the estimated workload in hours/week'));
    await tester.pump();
    await tester.tap(find.text('1-3 Hours'));
    await tester.pump();
    await tester.pump();
    expect(find.text('1-3 Hours'), findsOneWidget);

    // Test choosing grade
    await tester.ensureVisible(
        find.text('Choose the grade you received for this course'));

    await tester
        .tap(find.text('Choose the grade you received for this course'));
    await tester.pump();

    await tester.tap(find.text('A'));
    await tester.pump();
    expect(find.text('A'), findsOneWidget);

    // Test adding tags
    await tester.tap(find.text('+ Add tags for this course'));
    await tester.pump();

    // Test cancel adding tags
    await tester.tap(find.text('Cancel'));
    await tester.pump();

    await tester.tap(find.text('+ Add tags for this course'));
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(TextField, 'Enter tag name'), 'project');
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.widgetWithText(Chip, 'project'), findsOneWidget);

    // Remove the tag
    await tester.tap(find.descendant(
      of: find.byType(Chip),
      matching: find.byIcon(Icons.cancel),
    ));
    await tester.pump();
    expect(find.widgetWithText(Chip, 'project'), findsNothing);

    await tester.tap(find.text('+ Add tags for this course'));
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(TextField, 'Enter tag name'), 'project');
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Test pressing tag info
    await tester
        .tap(find.widgetWithIcon(IconButton, Icons.info_outline_rounded));
    await tester.pump();
    expect(
        find.text('Tags are keywords that can be associated with this course.'),
        findsOneWidget);
    await tester.tapAt(const Offset(400.0, 84.0));
    await tester.pump();

    // Test dragging difficulty rating slider
    await tester.drag(find.byType(Slider), const Offset(5.0, 0.0));
    await tester.pump();

    // Test dragging course rating slider
    await tester.drag(find.byType(RatingBar), const Offset(5.0, 0.0));
    await tester.pump();

    // Test adding review detail
    await tester.enterText(
        find.widgetWithText(TextFormField,
            'Write your reviews and thoughts about the course here:'),
        "Test Review");
    await tester.pump();
  });

  testWidgets('Test form validator', (WidgetTester tester) async {
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

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: WriteReviewPage(
              courseService: mockCourseService,
              instructorService: mockInstructorService,
            ),
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Submit!'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit!'));
    await tester.pump();
  });
}
