import 'package:discourse/pages/discussionforum/create_discussion_entry_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import 'mocks/like_dislike_comment_bar_test.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Test the components are loaded correctly',
      (WidgetTester tester) async {
    MockDiscussionService mockDiscussionService = MockDiscussionService();

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: CreateDiscussionEntryPage(
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Enter title...'), findsOneWidget);
    expect(find.text('Add tags (required) +'), findsOneWidget);
    expect(find.text('Body text...'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.widgetWithText(ElevatedButton, 'Post!'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test inputting data into form', (WidgetTester tester) async {
    MockDiscussionService mockDiscussionService = MockDiscussionService();

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: CreateDiscussionEntryPage(
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter title...'), 'test title');
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Add tags (required) +'),
        'test tag');
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Body text...'), 'test body');
    await tester.pump();
  });

  testWidgets('Test error messages', (WidgetTester tester) async {
    MockDiscussionService mockDiscussionService = MockDiscussionService();

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: CreateDiscussionEntryPage(
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Post!'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Post!'));
    await tester.pump();

    expect(find.text('Please enter the discussion title'), findsOneWidget);
    expect(find.text('Discussion body cannot be empty.'), findsOneWidget);
    expect(find.text('Please add tags to describe your post.'), findsOneWidget);
  });
}
