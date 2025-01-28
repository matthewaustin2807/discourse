import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/marketplace/listing_card.dart';
import 'package:discourse/components/searchBarWithoutButton.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Page to show all available market page listing
class MarketPage extends StatefulWidget {
  const MarketPage({super.key, required this.marketPageItemService});
  final MarketPageItemService marketPageItemService;
  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List<MarketPageItem> _allItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMarketItems();
  }

  /// Loads all marketpage items
  void _loadMarketItems() {
    widget.marketPageItemService.getAllItems().then((items) {
      setState(() {
        _allItems = items;
      });
    });
  }

  /// Search marketpage item through the search bar
  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  /// Gets the marketpage item based on user query
  List<MarketPageItem> _getFilteredItems() {
    if (_searchQuery.isEmpty) {
      return _allItems;
    }
    return _allItems
        .where((item) =>
            item.itemName.toLowerCase().contains(_searchQuery) ||
            (item.tags.any((tag) =>
                tag.tagDescription.toLowerCase().contains(_searchQuery))))
        .toList();
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          DiscourseAppBar(
            parentContext: context,
            pageName: 'Market',
            isForm: false,
            type: "marketplace",
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(children: [
                SearchModule(
                  callback: _onSearch,
                  initialQuery: _searchQuery,
                  searchBarText: "Search an item...",
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: screenSize.width,
                      maxHeight: screenSize.height * 0.6),
                  child: ListView(
                    padding: const EdgeInsets.only(top: 0),
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Semantics(
                          label: 'List of items in the market place',
                          child: Column(
                            children: [
                              ..._getFilteredItems().map((item) {
                                return ListingCard(item: item);
                              })
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Container(
                margin: const EdgeInsets.only(right: 16),
                width: screenSize.width * 0.15,
                height: screenSize.width * 0.15,
                child: Semantics(
                  label: 'Create a market listing',
                  button: true,
                  child: FloatingActionButton(
                      onPressed: () {
                        appState.changePages('/createmarketlisting');
                      },
                      child: const Icon(Icons.add, size: 36)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
