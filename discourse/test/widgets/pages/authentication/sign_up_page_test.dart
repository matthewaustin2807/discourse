import 'package:discourse/pages/authentication/sign_up_page.dart';
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

  testWidgets('Sign Up Page Widget Test', (WidgetTester tester) async {
    final _router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignUpPage(),
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
    expect(find.text('Confirm Password'), findsExactly(2));
    expect(find.widgetWithText(ElevatedButton, 'Sign Up!'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Sign In!'), findsOneWidget);
    expect(find.byType(TextFormField), findsExactly(3));

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test Inputting Values to Fields', (WidgetTester tester) async {
    final _router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignUpPage(),
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

    await tester.enterText(
        find.ancestor(
          of: find.text('Confirm Password'),
          matching: find.byType(TextFormField),
        ),
        'password');
    await tester.pump();
  });

  testWidgets('Test Validators', (WidgetTester tester) async {
    final _router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignUpPage(),
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
        'a');
    await tester.pump();

    await tester.enterText(
        find.ancestor(
          of: find.text('Input password'),
          matching: find.byType(TextFormField),
        ),
        'a');
    await tester.pump();

    await tester.enterText(
        find.ancestor(
          of: find.text('Confirm Password'),
          matching: find.byType(TextFormField),
        ),
        'b');
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up!'));
    await tester.pump();

    expect(find.text('Invalid Email Address'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    expect(find.text('Password does not match'), findsOneWidget);

    await tester.enterText(
        find.ancestor(
          of: find.text('Input Email'),
          matching: find.byType(TextFormField),
        ),
        '');
    await tester.pump();

    await tester.enterText(
        find.ancestor(
          of: find.text('Input password'),
          matching: find.byType(TextFormField),
        ),
        '');
    await tester.pump();

    await tester.enterText(
        find.ancestor(
          of: find.text('Confirm Password'),
          matching: find.byType(TextFormField),
        ),
        '');
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up!'));
    await tester.pump();

    expect(find.text('Please Enter Your Email'), findsOneWidget);
    expect(find.text('Please Enter Your Password'), findsOneWidget);
    expect(find.text('Please Confirm Your Password'), findsOneWidget);
  });
}
