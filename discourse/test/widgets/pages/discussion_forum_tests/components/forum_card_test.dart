import 'package:discourse/components/discussionforum/forum_card.dart';
import 'package:discourse/components/discussionforum/like_dislike_comment_bar.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/firebase_model/discussion_entry_firebase.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../firebase_test_mock.dart';
import '../mocks/like_dislike_comment_bar_test.mocks.dart';

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

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ForumCard(
              entry: entry,
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    expect(find.text('test name'), findsOneWidget);
    expect(find.text('12/04/2024'), findsOneWidget);
    expect(find.text('test title'), findsOneWidget);
    expect(find.widgetWithText(TagWidget, 'tags'), findsOneWidget);
    expect(find.byType(LikeDislikeCommentBar), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
