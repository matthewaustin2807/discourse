import 'package:discourse/components/bottomNavBar.dart';
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
  testWidgets('Test for Bottom Nav Bar UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) {
        final appState = ApplicationState();
        appState.init();
        return appState;
      }),
    ], child: const MaterialApp(home: BottomNavBar())));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Digest'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Forum'), findsOneWidget);
    expect(find.text('Market'), findsOneWidget);

    expect(find.byIcon(Icons.list), findsOneWidget);
    expect(find.byIcon(Icons.edit_square), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.people), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
