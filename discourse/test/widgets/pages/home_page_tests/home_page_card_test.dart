import 'package:discourse/components/home_page_card.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Test the home page card for Review Digest',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: const MaterialApp(
          home: Scaffold(
            body: HomePageCard(0),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
        find.byIcon(
          Icons.list,
        ),
        findsOneWidget);
    expect(find.text('Review Digest'), findsOneWidget);
    expect(find.text('Check out some of the top reviewed courses!'),
        findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test the home page card for Write a Review',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: const MaterialApp(
          home: Scaffold(
            body: HomePageCard(1),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
        find.byIcon(
          Icons.edit_square,
        ),
        findsOneWidget);
    expect(find.text('Write a Review!'), findsOneWidget);
    expect(
        find.text(
          'Write reviews for courses you’ve taken!',
        ),
        findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test the home page card for Discussion Forum',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: const MaterialApp(
          home: Scaffold(
            body: HomePageCard(2),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
        find.byIcon(
          Icons.people,
        ),
        findsOneWidget);
    expect(find.text('Discussion Forum'), findsOneWidget);
    expect(find.text('Get more answers from the community!'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test the home page card for Market Place',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: const MaterialApp(
          home: Scaffold(
            body: HomePageCard(3),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.shopping_bag), findsOneWidget);
    expect(find.text('Market Place'), findsOneWidget);
    expect(find.text('Find new and used course materials!'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
