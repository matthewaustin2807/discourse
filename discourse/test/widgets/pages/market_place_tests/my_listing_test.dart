import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/marketplace/my_listing_card.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/pages/marketpage/my_listing_page.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:discourse/service/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:discourse/state/application_state.dart';

import '../firebase_test_mock.dart';
import 'my_listing_test.mocks.dart';

@GenerateMocks([MarketPageItemService, UserService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test the presence of all necessary components in MyListingPage',
      (WidgetTester tester) async {
    List<MarketPageItem> mockItems = [
      const MarketPageItem(
          id: "1",
          imageLink: "",
          itemName: "Item 1",
          listerName: "name",
          listerId: "userId",
          itemCondition: "New",
          itemDescription: "itemDescription",
          tags: []),
      const MarketPageItem(
          id: "2",
          imageLink: "",
          itemName: "Item 2",
          listerName: "name",
          listerId: "userId",
          itemCondition: "Used",
          itemDescription: "itemDescription",
          tags: [])
    ];

    MockMarketPageItemService mockMarketItemService =
        MockMarketPageItemService();
    MockUserService mockUserService = MockUserService();

    when(mockUserService.getCurrentUserUid()).thenAnswer((_) async => 'userId');
    when(mockMarketItemService.getItemsByListerId('userId'))
        .thenAnswer((_) async => mockItems);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MyListingPage(
              marketPageItemService: mockMarketItemService,
              userService: mockUserService,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Listings'), findsOneWidget);
    expect(find.byType(DiscourseAppBar), findsOneWidget);

    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.byType(MyListingCard), findsNWidgets(2));

    expect(find.byType(TextField), findsOneWidget);

    expect(find.text('No listings found.'), findsNothing);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test empty list message when no items found',
      (WidgetTester tester) async {
    List<MarketPageItem> mockItems = [];

    MockMarketPageItemService mockMarketItemService =
        MockMarketPageItemService();
    MockUserService mockUserService = MockUserService();

    when(mockUserService.getCurrentUserUid()).thenAnswer((_) async => 'userId');
    when(mockMarketItemService.getItemsByListerId('userId'))
        .thenAnswer((_) async => mockItems);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MyListingPage(
              marketPageItemService: mockMarketItemService,
              userService: mockUserService,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No listings found.'), findsOneWidget);
  });
}
