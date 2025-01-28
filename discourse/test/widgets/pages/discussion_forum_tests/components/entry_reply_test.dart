import 'package:discourse/components/discussionforum/entry_reply.dart';
import 'package:discourse/components/discussionforum/like_dislike_comment_bar.dart';
import 'package:discourse/model/firebase_model/discussion_reply_firebase.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

    DiscussionReplyFirebase reply = DiscussionReplyFirebase(
      replierId: 'a',
      replierName: 'test name',
      replyBody: 'test reply',
      replyId: '123',
      replyIds: [],
      datePosted: '12/04/2024',
      likes: 2,
      dislikes: 2,
    );
    
    when(mockDiscussionService.addReplyToEntry(reply, 'a')).thenAnswer((_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: EntryReply(
              level: 0,
              callback: () {},
              reply: reply,
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    expect(find.text('test name'), findsOneWidget);
    expect(find.text('12/04/2024'), findsOneWidget);
    expect(find.text('test reply'), findsOneWidget);
    expect(find.byType(LikeDislikeCommentBar), findsOneWidget);
    expect(find.byType(ExpansionTile), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));

    await tester.tap(find.byType(TextButton));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField), 'a');
    await tester.pump();
  });

  testWidgets(
      'Test that there are multiple Entry Replies if a reply has another reply',
      (WidgetTester tester) async {
    MockDiscussionService mockDiscussionService = MockDiscussionService();

    DiscussionReplyFirebase reply = DiscussionReplyFirebase(
      replierId: 'a',
      replierName: 'test name',
      replyBody: 'test reply',
      replyId: '123',
      replies: [
        DiscussionReplyFirebase(
          replierId: 'b',
          replierName: 'test name 2',
          replyBody: 'test reply 2',
          replyId: '1234',
          replyIds: ['b'],
          datePosted: '12/05/2024',
          likes: 2,
          dislikes: 2,
        )
      ],
      replyIds: ['b'],
      datePosted: '12/04/2024',
      likes: 2,
      dislikes: 2,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: EntryReply(
              level: 0,
              callback: () {},
              reply: reply,
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    expect(find.text('test name'), findsOneWidget);
    expect(find.text('12/04/2024'), findsOneWidget);
    expect(find.text('test reply'), findsOneWidget);
    expect(find.text('test name 2'), findsOneWidget);
    expect(find.text('12/05/2024'), findsOneWidget);
    expect(find.text('test reply 2'), findsOneWidget);
    expect(find.byType(LikeDislikeCommentBar), findsNWidgets(2));
    expect(find.byType(ExpansionTile), findsNWidgets(2));
    expect(find.byType(TextButton), findsNWidgets(2));
    expect(find.byType(EntryReply), findsNWidgets(2));
  });
}
