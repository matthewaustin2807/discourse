import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:discourse/pages/authentication/landing_page.dart';

String _discourseLogoURI = "assets/logos/discourse_logo.png";
void main() {
  testWidgets('Landing Page Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LandingPage()));

    // Verify the App Name and Logo are Visible
    expect(find.image(AssetImage(_discourseLogoURI)), findsOneWidget);
    expect(find.text('Discourse'), findsOneWidget);

    // Verify the Buttons are Visible
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
  });
}
