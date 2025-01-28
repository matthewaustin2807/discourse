import 'package:discourse/pages/authentication/sign_in_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Sign In Page Widget Test', (WidgetTester tester) async {
    final _router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignInPage(),
      ),
    ]);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp.router(
          routerConfig: _router,
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In!'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Register!'), findsOneWidget);
    expect(find.byType(TextFormField), findsExactly(2));

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test inputting values to fields', (WidgetTester tester) async {
    final _router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignInPage(),
      ),
    ]);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp.router(
          routerConfig: _router,
        ),
      ),
    );

    await tester.pump();

    await tester.enterText(
        find.ancestor(
          of: find.text('Input Email'),
          matching: find.byType(TextFormField),
        ),
        'test@gmail.com');
    await tester.pump();

    await tester.enterText(
        find.ancestor(
          of: find.text('Input password'),
          matching: find.byType(TextFormField),
        ),
        'password');
    await tester.pump();
  });

  testWidgets('Test Validators', (WidgetTester tester) async {
    final _router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignInPage(),
      ),
    ]);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp.router(
          routerConfig: _router,
        ),
      ),
    );

    await tester.enterText(
        find.ancestor(
          of: find.text('Input Email'),
          matching: find.byType(TextFormField),
        ),
        'a');
    await tester.pump();

    await tester.enterText(
        find.ancestor(
          of: find.text('Input password'),
          matching: find.byType(TextFormField),
        ),
        'password');
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In!'));
    await tester.pump();

    expect(find.text('Invalid Email Address'), findsOneWidget);
  });
}
