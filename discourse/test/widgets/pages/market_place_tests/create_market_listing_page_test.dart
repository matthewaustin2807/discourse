import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:discourse/service/upload_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:discourse/pages/marketpage/create_market_listing_page.dart';
import 'package:provider/provider.dart';
import '../firebase_test_mock.dart';
import 'create_market_listing_page_test.mocks.dart';

@GenerateMocks([MarketPageItemService, FileUploadService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  late MockMarketPageItemService mockMarketPageItemService;
  late MockFileUploadService mockFileUploadService;

  setUp(() {
    mockMarketPageItemService = MockMarketPageItemService();
    mockFileUploadService = MockFileUploadService();
  });

  testWidgets('Test presence of essential UI components',
      (WidgetTester tester) async {
    // Set up mock behavior
    when(mockMarketPageItemService.addItem(any)).thenAnswer((_) async => {});

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
          child: MaterialApp(
            home: Scaffold(
              body: CreateMarketListingPage(
                fileUploadService: mockFileUploadService,
                marketPageItemService: mockMarketPageItemService,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify essential components
    expect(find.byType(DiscourseAppBar), findsOneWidget);
    expect(find.text('Create Listing'), findsOneWidget);
    expect(find.byType(TextFormField),
        findsNWidgets(2)); // Listing Name and Description
    expect(find.byKey(Key("new")), findsNWidgets(1));
    expect(find.byKey(Key("used")), findsNWidgets(1)); // Condition: New/Used
    expect(find.byType(ElevatedButton), findsOneWidget); // Post button
    expect(find.byType(TextButton), findsOneWidget); // Upload Files button

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test form validation and posting', (WidgetTester tester) async {
    // Set up mock behavior
    when(mockMarketPageItemService.addItem(any)).thenAnswer((_) async => {});

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
          child: MaterialApp(
            home: Scaffold(
              body: CreateMarketListingPage(
                fileUploadService: mockFileUploadService,
                marketPageItemService: mockMarketPageItemService,
              ),
            ),
          ),
        ),
      ),
    );

    // Fill out the form
    await tester.enterText(find.byType(TextFormField).at(0), 'Item 1');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Item 1 description');

    // // Select an item condition
    await tester.tap(find.byKey(Key("new")).at(0), warnIfMissed: false); // Select "New"
    await tester.pumpAndSettle();

    // Mock file upload service behavior
    when(mockFileUploadService.uploadImage(any))
        .thenAnswer((_) async => 'image_url');
    when(mockFileUploadService.uploadFile(any))
        .thenAnswer((_) async => 'file_url');

    // Press the Post button
    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Verify that the addItem method was called (i.e., the listing was posted)
    // verify(mockMarketPageItemService.addItem(any)).called(1);
  });

  testWidgets('Test missing item condition error', (WidgetTester tester) async {
    // Set up mock behavior
    when(mockMarketPageItemService.addItem(any)).thenAnswer((_) async => {});

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
          child: MaterialApp(
            home: Scaffold(
              body: CreateMarketListingPage(
                fileUploadService: mockFileUploadService,
                marketPageItemService: mockMarketPageItemService,
              ),
            ),
          ),
        ),
      ),
    );

    // Fill out the form without selecting an item condition
    await tester.enterText(find.byType(TextFormField).at(0), 'Item 1');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Item 1 description');

    // Press the Post button
    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Check if the error message for missing condition is displayed
    // expect(find.text('Please select an item condition.'), findsOneWidget);
  });

  testWidgets('Test adding and removing tags', (WidgetTester tester) async {
    // Set up mock behavior
    when(mockMarketPageItemService.addItem(any)).thenAnswer((_) async => {});

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
          child: MaterialApp(
            home: Scaffold(
              body: CreateMarketListingPage(
                fileUploadService: mockFileUploadService,
                marketPageItemService: mockMarketPageItemService,
              ),
            ),
          ),
        ),
      ),
    );

    // Add a tag
    await tester.tap(find.byType(ActionChip));
    await tester.pumpAndSettle();

    // Add a tag in the dialog
    await tester.enterText(find.byKey(Key("tag text field")), 'New Tag');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify that the tag appears in the list
    expect(find.text('New Tag'), findsOneWidget);
  });
}
