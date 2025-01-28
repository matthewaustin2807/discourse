import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/pages/marketpage/listing_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../firebase_test_mock.dart';
import 'detail_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets(
      'Test the presence of all necessary components in ListingDetailPage',
      (WidgetTester tester) async {
    MarketPageItem mockItem = MarketPageItem(
        id: "1",
        itemName: "Item 1",
        listerName: "name",
        listerId: "userId",
        itemCondition: "New",
        itemDescription: "Item description",
        tags: [],
        imageLink: "",
        fileUrls: ["https://example.com/file1.jpg"]);

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ListingDetailPage(
              item: mockItem,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Listing Detail'), findsOneWidget);
    expect(find.byType(DiscourseAppBar), findsOneWidget);
    expect(find.byKey(Key("pic")), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item description'), findsOneWidget);
    expect(find.text('Listed by:'), findsOneWidget);

    expect(find.byType(TagWidget), findsNothing);

    expect(find.byType(FloatingActionButton), findsOneWidget);

    // AccessibilityTests
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester, meetsGuideline(iOSTapTargetGuideline));
  });

  testWidgets('Test download failure and error message',
      (WidgetTester tester) async {
    MarketPageItem mockItem = MarketPageItem(
        id: "1",
        itemName: "Item 1",
        listerName: "name",
        listerId: "userId",
        itemCondition: "New",
        itemDescription: "Item description",
        tags: [],
        imageLink: "",
        fileUrls: ["https://example.com/file1.jpg"]);

    MockDio mockDio = MockDio();

    when(mockDio.download(any, any))
        .thenThrow(DioError(requestOptions: RequestOptions(path: '')));

    await tester.pumpWidget(
      ChangeNotifierProvider<ApplicationState>(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          home: Scaffold(
            body: ListingDetailPage(
              item: mockItem,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  });
}
