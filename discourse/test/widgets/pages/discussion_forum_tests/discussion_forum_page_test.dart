import 'package:discourse/components/discussionforum/forum_card.dart';
import 'package:discourse/components/searchBarWithoutButton.dart';
import 'package:discourse/model/firebase_model/discussion_entry_firebase.dart';
import 'package:discourse/pages/discussionforum/discussion_forum_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

    DiscussionEntryFirebase entry = DiscussionEntryFirebase(
      entryId: '123',
      userId: 'a',
      username: 'test name',
      discussionTitle: 'test title',
      tags: ['tags'],
      discussionBody: 'test body',
      datePosted: '12/04/2024',
      likes: 2,
      dislikes: 2,
      replyIds: [],
      replies: [],
    );

    List<DiscussionEntryFirebase> entries = [entry];

    when(mockDiscussionService.getAllDiscussionEntries())
        .thenAnswer((_) async => entries);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: DiscussionForumPage(
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(ForumCard), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test Searching for a specific entry',
      (WidgetTester tester) async {
    MockDiscussionService mockDiscussionService = MockDiscussionService();

    DiscussionEntryFirebase entry = DiscussionEntryFirebase(
      entryId: '123',
      userId: 'a',
      username: 'test name',
      discussionTitle: 'test title',
      tags: ['tags'],
      discussionBody: 'test body',
      datePosted: '12/04/2024',
      likes: 2,
      dislikes: 2,
      replyIds: [],
      replies: [],
    );

    DiscussionEntryFirebase entry2 = DiscussionEntryFirebase(
      entryId: '123',
      userId: 'a',
      username: 'test name',
      discussionTitle: 'new title',
      tags: ['new tags'],
      discussionBody: 'test body',
      datePosted: '12/04/2024',
      likes: 2,
      dislikes: 2,
      replyIds: [],
      replies: [],
    );

    List<DiscussionEntryFirebase> entries = [entry, entry2];

    when(mockDiscussionService.getAllDiscussionEntries())
        .thenAnswer((_) async => entries);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: DiscussionForumPage(
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(ForumCard), findsNWidgets(2));

    await tester.enterText(find.byType(SearchModule), 'new title');
    await tester.pump();

    expect(find.byType(ForumCard), findsOneWidget);
  });
}
