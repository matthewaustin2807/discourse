import 'package:flutter/material.dart';

/// Search Bar without Dropdown
class SearchModule extends StatefulWidget {
  const SearchModule({super.key, required this.callback, this.initialQuery = '', this.searchBarText = "Search"});
  final Function(String) callback;
  final String initialQuery; 
  final String searchBarText; 

  @override
  _SearchModuleState createState() => _SearchModuleState();
}

class _SearchModuleState extends State<SearchModule> {
  late TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenSize.width * 0.95,
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: widget.searchBarText,
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                widget.callback(value); 
              },
            ),
          ),
        ],
      ),
    );
  }
}
