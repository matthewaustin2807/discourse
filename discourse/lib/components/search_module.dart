import 'package:discourse/model/root_model.dart';
import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

/// Search bar with Dropdown
class SearchModule<E extends RootModel> extends StatelessWidget {
  const SearchModule(
      {super.key, required this.callbackAction, required this.data});
  final List<E> data;
  final Function(String) callbackAction;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenSize.width * 0.95,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 68,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SearchableDropdown<E>(
                trailingIcon: const SizedBox(height:50, width: 50, child: Icon(Icons.keyboard_arrow_down_outlined, size: 32)),
                trailingClearIcon: const SizedBox(height:50, width: 50, child: Icon(Icons.close, size: 32)),
                hintText: const Text('Search...',
                    style: TextStyle(fontFamily: 'RegularText')),
                items: List.generate(data.length, (idx) {
                  return SearchableDropdownMenuItem(
                      label: data[idx].getLabel(),
                      child: Semantics(
                        label: data[idx].getLabel(),
                        child: Text(
                          data[idx].getLabel(),
                          style: const TextStyle(fontFamily: 'RegularText'),
                        ),
                      ),
                      value: data[idx]);
                }),
                onChanged: (value) {
                  if (value == null) {
                    callbackAction('');
                  } else {
                    callbackAction(value.getKey());
                  }
                },
              )),
        ],
      ),
    );
  }
}
