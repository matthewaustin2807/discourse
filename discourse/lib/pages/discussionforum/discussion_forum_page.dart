import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/discussionforum/forum_card.dart';
import 'package:discourse/components/searchBarWithoutButton.dart';
import 'package:discourse/model/firebase_model/discussion_entry_firebase.dart';
import 'package:discourse/service/discussion_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Discussion Forum Page
class DiscussionForumPage extends StatefulWidget {
  const DiscussionForumPage({super.key, required this.discussionService});
  final DiscussionService discussionService;

  @override
  State<DiscussionForumPage> createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> {
  late Future<List<DiscussionEntryFirebase>> futureDiscussionEntries;
  List<DiscussionEntryFirebase> _allEntries = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDiscussionForumItems();
    futureDiscussionEntries =
        widget.discussionService.getAllDiscussionEntries();
  }

  /// Loads all discussion forum items
  void _loadDiscussionForumItems() {
    widget.discussionService.getAllDiscussionEntries().then((entries) {
      setState(() {
        _allEntries = entries;
      });
    });
  }

  /// Change the query string based on user input
  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  /// Gets all discussion entry based on the user query
  List<DiscussionEntryFirebase> _getFilteredItems() {
    if (_searchQuery.isEmpty) {
      return _allEntries;
    }
    return _allEntries
        .where((entry) =>
            entry.discussionTitle.toLowerCase().contains(_searchQuery) ||
            (entry.tags.any((tag) => tag.toLowerCase().contains(_searchQuery))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Center(
      child: ListView(
        children: [
          DiscourseAppBar(
            parentContext: context,
            pageName: 'Discussion Forum',
            isForm: false,
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(children: [
                SearchModule(
                  callback: _onSearch,
                  initialQuery: _searchQuery,
                  searchBarText: "Search discussion...",
                ),
                Container(
                    constraints: BoxConstraints(
                        maxWidth: screenSize.width,
                        maxHeight: screenSize.height * 0.6),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0),
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Semantics(
                            label: 'List of discussions',
                            child: Column(
                              children: [
                                ..._getFilteredItems().map((item) {
                                  return ForumCard(
                                    entry: item,
                                    discussionService: widget.discussionService,
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ]),
              Container(
                margin: const EdgeInsets.only(right: 16),
                width: screenSize.width * 0.15,
                height: screenSize.width * 0.15,
                child: Semantics(
                  label: 'Create a new Discussion',
                  button: true,
                  child: FloatingActionButton(
                      onPressed: () {
                        appState.changePages('/creatediscussionpage');
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
