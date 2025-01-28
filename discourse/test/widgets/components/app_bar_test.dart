import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../pages/firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Test all components are present when loaded in home page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(body: Builder(builder: (context) {
            return DiscourseAppBar(
                parentContext: context, pageName: "Discourse", isForm: false);
          })),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Discourse'), findsOneWidget);
    expect(find.widgetWithIcon(IconButton, Icons.menu), findsOneWidget);
  });

  testWidgets('Test that a back button is present if not in homepage',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(body: Builder(builder: (context) {
            return DiscourseAppBar(
                parentContext: context,
                pageName: "Review Digest",
                isForm: false);
          })),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Review Digest'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
  });

  testWidgets(
      'Test that pressing back button in a page that is a form will triger an alert dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) {
          final appState = ApplicationState();
          appState.init();
          appState.navigateFromBottomNav(1);
          return appState;
        },
        child: MaterialApp(
          home: Scaffold(body: Builder(builder: (context) {
            return DiscourseAppBar(
                parentContext: context,
                pageName: "Review Digest",
                isForm: true);
          })),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Review Digest'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pump();

    await tester.tap(find.byType(BackButton));
    await tester.pump();


    await tester.tap(find.widgetWithText(TextButton, 'Exit'));
    await tester.pump();
  });
}
