/// Model class to reprsent Marketpage Item in Firestore
class MarketPageItemFirebase {
  const MarketPageItemFirebase({
    required this.id,
    required this.listerId,
    required this.imageLink,
    required this.itemName,
    required this.itemCondition,
    required this.itemDescription,
    required this.tags,
    required this.listerName,
    this.fileUrls,
  });

  final String id;
  final String listerId;
  final String imageLink;
  final String itemName;
  final String itemCondition;
  final String itemDescription;
  final List<String> tags;
  final List<String>? fileUrls;
  final String listerName;

  // Convert the MarketPageItem instance into a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listerId': listerId,
      'listerName': listerName,
      'imageLink': imageLink,
      'itemName': itemName,
      'itemCondition': itemCondition,
      'itemDescription': itemDescription,
      'tags': tags,
      'fileUrls': fileUrls ?? [],
    };
  }

  // Create a MarketPageItem instance from Firestore DocumentSnapshot
  factory MarketPageItemFirebase.fromDocument(Map<String, dynamic> doc) {
    return MarketPageItemFirebase(
      id: doc['id'],
      listerId: doc['listerId'],
      imageLink: doc['imageLink'],
      itemName: doc['itemName'],
      itemCondition: doc['itemCondition'],
      itemDescription: doc['itemDescription'],
      tags: List<String>.from(doc['tags'] ?? []),
      fileUrls: List<String>.from(doc['fileUrls']),
      listerName: doc['listerName'],
    );
  }
}
