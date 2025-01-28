import 'package:discourse/model/tag.dart';

/// Class to represent marketpage item
class MarketPageItem {
  const MarketPageItem(
      {required this.id,
      required this.listerId,
      required this.imageLink,
      required this.itemName,
      required this.itemCondition,
      required this.itemDescription,
      required this.tags,
      required this.listerName,
      this.fileUrls});

  final String id;
  final String listerId;
  final String imageLink;
  final String itemName;
  final String itemCondition;
  final String itemDescription;
  final List<Tag> tags;
  final List<String>? fileUrls;
  final String listerName;
}
