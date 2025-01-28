import 'package:flutter/material.dart';
import 'package:discourse/constants/appColor.dart';

/// Widget for UI representation of a Tag
class TagWidget extends StatelessWidget {
  const TagWidget({super.key, required this.tagName});
  final String tagName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
      margin: const EdgeInsets.only(right: 5, top: 2),
      decoration: BoxDecoration(
          color: AppColor().tagColor, borderRadius: BorderRadius.circular(12)),
      child: Semantics(
          label: tagName,
          child: Text(
            tagName,
            style: const TextStyle(fontFamily: 'RegularText', fontSize: 16),
          )),
    );
  }
}
