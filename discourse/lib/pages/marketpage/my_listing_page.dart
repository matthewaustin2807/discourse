import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/marketplace/my_listing_card.dart';
import 'package:discourse/components/searchBarWithoutButton.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:discourse/service/user_service.dart';
import 'package:flutter/material.dart';

/// Page to show My Listings to the user.
class MyListingPage extends StatefulWidget {
  const MyListingPage(
      {super.key,
      required this.marketPageItemService,
      required this.userService});
  final MarketPageItemService marketPageItemService;
  final UserService userService;

  @override
  State<MyListingPage> createState() => _MyListingPageState();
}

class _MyListingPageState extends State<MyListingPage> {
  late Future<List<MarketPageItem>> _myMarketItemsFuture;
  List<MarketPageItem> _allItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _myMarketItemsFuture = Future.value([]);
    _loadItems();
  }

  /// Loads all my listing from firestore
  Future<void> _loadItems() async {
    try {
      final currentUserId = await widget.userService.getCurrentUserUid();
      _myMarketItemsFuture =
          widget.marketPageItemService.getItemsByListerId(currentUserId);
      _myMarketItemsFuture.then((items) {
        setState(() {
          _allItems = items;
        });
      });
    } catch (e) {
      print("Error loading user ID: $e");
    }
  }

  /// Search my listing items through the search bar
  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  /// Gets the My Listing Items based on user query
  List<MarketPageItem> _getFilteredItems() {
    if (_searchQuery.isEmpty) {
      return _allItems;
    }
    return _allItems
        .where((item) =>
            item.itemName.toLowerCase().contains(_searchQuery) ||
            item.tags.any((tag) =>
                tag.tagDescription.toLowerCase().contains(_searchQuery)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: <Widget>[
          DiscourseAppBar(
            parentContext: context,
            pageName: 'My Listings',
            isForm: false,
          ),
          SearchModule(callback: _onSearch),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width,
                maxHeight: screenSize.height * 0.9,
              ),
              child: Semantics(
                label: 'List of items created by the user',
                child: FutureBuilder<List<MarketPageItem>>(
                  future: _myMarketItemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No listings found.'));
                    } else {
                      List<MarketPageItem> items = _getFilteredItems();
                      return ListView(
                        padding: const EdgeInsets.only(top: 0),
                        children: List.generate(items.length, (idx) {
                          return IndexedSemantics(
                            index: idx,
                            child: MyListingCard(
                              item: items[idx],
                              onUnlist: () {
                                setState(() {
                                  items.removeAt(idx);
                                });
                              },
                            ),
                          );
                        }),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
