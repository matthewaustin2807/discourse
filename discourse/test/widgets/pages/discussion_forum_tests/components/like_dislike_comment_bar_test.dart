import 'package:discourse/components/discussionforum/like_dislike_comment_bar.dart';
import 'package:discourse/service/discussion_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../firebase_test_mock.dart';
import '../mocks/like_dislike_comment_bar_test.mocks.dart';

@GenerateMocks([DiscussionService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Test the components are loaded correctly',
      (WidgetTester tester) async {
    MockDiscussionService mockDiscussionService = MockDiscussionService();

    when(mockDiscussionService.addLikeOrDislike('a', true, true))
        .thenAnswer((_) async {});
    when(mockDiscussionService.addLikeOrDislike('a', true, false))
        .thenAnswer((_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: LikeDislikeCommentBar(
              id: 'a',
              isReply: true,
              likes: 5,
              dislikes: 5,
              replyLength: 5,
              discussionService: mockDiscussionService,
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_circle_down_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_circle_up_rounded), findsOneWidget);
    expect(find.byIcon(Icons.mode_comment_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_circle_down_rounded));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_circle_down_rounded));
    await tester.pump();

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
