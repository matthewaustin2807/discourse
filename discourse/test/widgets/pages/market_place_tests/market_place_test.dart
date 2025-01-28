import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/marketplace/listing_card.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/pages/marketpage/market_page.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:discourse/state/application_state.dart';

import '../firebase_test_mock.dart';
import 'market_place_test.mocks.dart';

@GenerateMocks([MarketPageItemService])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test the presence of all necessary components',
      (WidgetTester tester) async {
    List<MarketPageItem> mockItems = [
      MarketPageItem(
          id: "id",
          listerId: "listerId",
          listerName: "name",
          imageLink: "",
          itemName: "Item 1",
          itemCondition: "Used",
          itemDescription: "itemDescription",
          tags: []),
      MarketPageItem(
          id: "id",
          listerId: "listerId",
          listerName: "name",
          imageLink: "",
          itemName: "Item 2",
          itemCondition: "Used",
          itemDescription: "itemDescription",
          tags: [])
    ];
    MockMarketPageItemService mockMarketItemService =
        MockMarketPageItemService();
    when(mockMarketItemService.getAllItems())
        .thenAnswer((_) async => mockItems);

    // Create the test environment, wrapping ApplicationState with ChangeNotifierProvider
    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: MarketPage(
              marketPageItemService: mockMarketItemService,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Market'), findsOneWidget);
    expect(find.byType(DiscourseAppBar), findsOneWidget);

    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.byType(ListingCard), findsNWidgets(2));

    expect(find.byType(FloatingActionButton), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });
}
