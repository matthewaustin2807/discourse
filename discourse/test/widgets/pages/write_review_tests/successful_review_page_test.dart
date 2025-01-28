import 'package:discourse/pages/writereview/successful_review_page.dart';
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

  testWidgets('Test all components exist', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: const MaterialApp(
          home: Scaffold(
            body: SuccessfulReviewPage(),
          ),
        ),
      ),
    );

    expect(find.text('Congratulations!'), findsOneWidget);
    expect(find.text('Your Review Has Been Published!'), findsOneWidget);
    expect(find.text('It is now visible to other students and instructors.'),
        findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Take me back to the homepage'),
        findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'View my Review History'),
        findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
